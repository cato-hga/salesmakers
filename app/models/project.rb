class Project < ActiveRecord::Base
  #after_save :create_wall

  validates :name, presence: true, length: { minimum: 4 }
  validates :client, presence: true

  belongs_to :client
  has_many :area_types
  has_many :areas
  has_one :wall, as: :wallable
  has_many :day_sales_counts, as: :saleable

  default_scope { order(:name) }
  scope :visible, -> (person = nil) {
    return self.none unless person
    return self.all if person.position and person.position.hq?
    projects = Array.new
    for person_area in person.person_areas do
      next unless person_area.area
      projects << person_area.area.project unless projects.include? person_area.area.project
    end
    projects
  }

  def self.locations(project)
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
end
