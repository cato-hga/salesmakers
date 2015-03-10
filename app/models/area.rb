class Area < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  belongs_to :area_type
  belongs_to :project
  has_many :person_areas
  has_many :people, through: :person_areas
  has_many :managers, -> {
    where('person_areas.manages = true')
  }, class_name: Person, source: :person, through: :person_areas
  has_many :non_managers, -> {
    where('person_areas.manages = false')
  }, class_name: Person, source: :person, through: :person_areas
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
    return Area.all if person.position and
        (person.position.hq? or person.position.all_field_visibility?)
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

  default_scope { joins(:project).order('projects.name, areas.name') }

  def all_locations
    subtree_location_areas = LocationArea.where area_id: self.subtree_ids
    return Location.none if subtree_location_areas.empty?
    Location.where("id IN (#{subtree_location_areas.map(&:location_id).join(',')})")
  end

  def full_name
    "#{self.project.name} - #{self.name}"
  end
end
