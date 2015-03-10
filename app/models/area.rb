class Area < ActiveRecord::Base
  extend AreaAssociationsModelExtension
  include AreaScopesModelExtension

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  has_ancestry

  setup_assocations

  default_scope { joins('LEFT OUTER JOIN projects ON projects.id = areas.project_id').
      order('projects.name, areas.name') }

  delegate :client, to: :project

  def all_locations
    subtree_location_areas = LocationArea.where area_id: self.subtree_ids
    return Location.none if subtree_location_areas.empty?
    Location.where("id IN (#{subtree_location_areas.map(&:location_id).join(',')})")
  end

  def full_name
    "#{self.project.name} - #{self.name}"
  end
end
