# == Schema Information
#
# Table name: projects
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  client_id              :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#  workmarket_project_num :string
#  active                 :boolean          default(TRUE), not null
#

class Project < ActiveRecord::Base
  #after_save :create_wall

  def self.setup_validations
    validates :name, presence: true, length: { minimum: 4 }
    validates :client, presence: true
  end

  def self.setup_associations
    belongs_to :client
    has_many :area_types
    has_many :areas
    has_many :client_area_types
    has_many :client_areas
    # has_one :wall, as: :wallable
    has_many :day_sales_counts, as: :saleable
    has_many :shifts
    has_many :sprint_carriers
  end

  setup_validations
  setup_associations

  default_scope { order(:name) }

  strip_attributes

  def self.visible(person = nil)
    return Project.none unless person
    return Project.all if person.position and person.position.hq?
    project_ids = Array.new
    for person_area in person.person_areas do
      next unless person_area.area
      project_ids << person_area.area.project_id unless project_ids.include? person_area.area.project_id
    end
    Project.where id: project_ids.uniq
  end

  def self.location_areas(project)
    Location.
        joins(%{
              LEFT OUTER JOIN location_areas
                ON location_areas.location_id = locations.id
              LEFT OUTER JOIN areas
                ON areas.id = location_areas.area_id
              LEFT OUTER JOIN projects
                ON projects.id = areas.project_id
              }).where("projects.id = #{project.id}")
  end

  def self.location_client_areas(project)
    Location.
        joins(%{
              LEFT OUTER JOIN location_client_areas
                ON location_client_areas.location_id = locations.id
              LEFT OUTER JOIN client_areas
                ON client_areas.id = location_client_areas.area_id
              LEFT OUTER JOIN projects
                ON projects.id = client_areas.project_id
              }).where("projects.id = #{project.id}")
  end

  def active_people
    person_areas = Array.new
    people = Array.new
    areas = self.areas
    for area in areas.includes(person_areas: :person) do
      person_areas = person_areas.concat area.person_areas
    end
    for person_area in person_areas do
      people << person_area.person if person_area.person.active?
    end
    Person.where("\"people\".\"id\" IN (#{people.map(&:id).join(',')})")
  end

  def locations
    all_locations = Array.new
    for area in self.areas do
      all_locations << area.locations
    end
    Location.where(id: all_locations.flatten.uniq.map(&:id))
  end

  def locations_for_person(person)
    if person.position.hq?
      self.locations.ordered_by_name
    else
      person.locations.ordered_by_name
    end
  end

  def self.number_on_navigation_for_person person
    position = person.position
    return 0 unless position
    projects = {
        comcast: [
            'comcast_customer_create',
            'comcast_lead_index',
            'comcast_sale_index'
        ],
        sprint: [
            'sprint_sale_index'
        ],
        directv: [
            'directv_customer_create',
            'directv_lead_index',
            'directv_sale_index'
        ],
        vonage_retail: [
            'vonage_sale_index',
            'vonage_sale_create',
            'walmart_gift_card_create'
        ]
    }
    visible_projects = []
    for project_key in projects.keys do
      projects[project_key].each do |permission_key|
        permission = Permission.find_by(key: permission_key) || next
        visible_projects << project_key if position.permissions.include?(permission)
      end
    end
    visible_projects.uniq.count
  end

end
