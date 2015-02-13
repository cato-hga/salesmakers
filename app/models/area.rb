class Area < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  belongs_to :area_type
  belongs_to :project
  has_many :person_areas
  has_many :people, through: :person_areas
  has_one :wall, as: :wallable
  has_many :day_sales_counts, as: :saleable
  has_many :sales_performance_ranks, as: :rankable
  has_many :location_areas
  has_many :locations, through: :location_areas
  has_many :vonage_rep_sale_payout_brackets
  has_one :group_me_group
  has_ancestry

  delegate :client, to: :project

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

  scope :project_roots, ->(project = nil) {
    return Area.none unless project
    Area.roots.where(project: project).order(:name)
  }

  scope :roots, -> {
    areas = Array.new
    for area in Area.all do
      areas << area.root unless areas.include? area.root
    end
    return Area.none if areas.count < 1
    Area.where("id IN (#{areas.map(&:id).join(',')})").order(:name)
  }

  def managers
    person_areas = self.person_areas.where(manages: true)
    return Person.none if person_areas.count < 1
    managers = Array.new
    for person_area in person_areas do
      managers << person_area.person
    end
    Person.where("id IN (#{managers.map(&:id).join(',')})").order(:display_name)
  end

  def non_managers(only_active = false)
    if only_active
      person_areas = self.person_areas.joins(:person).where("people.active = true AND manages = false")
    else
      person_areas = self.person_areas.where(manages: false)
    end
    return Person.none if person_areas.count < 1
    non_managers = Array.new
    for person_area in person_areas do
      non_managers << person_area.person
    end
    Person.where("id IN (#{non_managers.map(&:id).join(',')})").order(:display_name)
  end

  def all_locations
    subtree_person_areas = LocationArea.where area_id: self.subtree_ids
    return Location.none unless subtree_person_areas.count > 0
    Location.where("id IN (#{subtree_person_areas.map(&:location_id).join(',')})")
  end
end
