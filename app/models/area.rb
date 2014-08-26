class Area < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  belongs_to :area_type
  belongs_to :project
  has_many :person_areas
  has_many :people, through: :person_areas
  has_ancestry


  scope :visible, ->(person = nil) {
    return Area.none unless person
    return Area.all if person.position and person.position.hq?
    areas = Array.new
    person_areas = person.person_areas

    for person_area in person_areas do
      if person_area.manages?
        areas = areas.concat person_area.area.subtree.to_a
      else
        areas << person_area.area
      end
    end

    return Area.none if areas.count < 1

    Area.where("id IN (#{areas.map(&:id).join(',')})")
  }
end
