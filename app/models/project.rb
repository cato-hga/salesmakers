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
    has_one :wall, as: :wallable
    has_many :day_sales_counts, as: :saleable
  end

  setup_validations
  setup_associations

  default_scope { order(:name) }

  def self.visible(person = nil)
    return Project.none unless person
    return Project.all if person.position and person.position.hq?
    projects = Array.new
    for person_area in person.person_areas do
      next unless person_area.area
      projects << person_area.area.project unless projects.include? person_area.area.project
    end
    projects
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
    all_locations.flatten.uniq
  end

  def locations_for_person(person)
    if person.position.hq?
      self.locations.sort_by { |l| l.name }
    else
      person.locations.sort_by { |l| l.name }
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
