class Project < ActiveRecord::Base
  after_save :create_wall

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
      projects << person_area.area.project unless projects.include? person_area.area.project
    end
    projects
  }

  def create_wall
    return if self.wall
    Wall.create wallable: self
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
end
