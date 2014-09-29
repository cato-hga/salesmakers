class Area < ActiveRecord::Base
  after_save :create_wall

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  belongs_to :area_type
  belongs_to :project
  has_many :person_areas
  has_many :people, through: :person_areas
  has_one :wall, as: :wallable
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

  scope :member_of, ->(person = nil) {
    return Area.none unless person
    areas = Array.new
    if person.position and person.position.hq?
      for area in Area.all do
        areas << area.root unless areas.include? area.root
      end
      return Area.where("id IN (#{areas.map(&:id).join(',')})")
    end
    person_areas = person.person_areas

    for person_area in person_areas do
      areas << person_area.area
    end

    return Area.none if areas.count < 1

    Area.where("id IN (#{areas.map(&:id).join(',')})")
  }

  scope :roots, -> {
    areas = Array.new
    for area in Area.all do
      areas << area.root unless areas.include? area.root
    end
    return Area.none if areas.count < 1
    Area.where("id IN (#{areas.map(&:id).join(',')})")
  }

  private

    def create_wall
      return if self.wall
      Wall.create wallable: self
    end
end
