class Project < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 4 }
  validates :client, presence: true

  belongs_to :client
  has_many :area_types
  has_many :areas

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
end
