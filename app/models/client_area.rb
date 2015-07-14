class ClientArea < ActiveRecord::Base
  extend ClientAreaAssociationsModelExtension
  include ClientAreaScopesModelExtension

  validates :name, presence: true, length: { minimum: 3 }
  validates :client_area_type, presence: true

  has_paper_trail
  has_ancestry

  setup_assocations

  default_scope { joins('LEFT OUTER JOIN projects ON projects.id = client_areas.project_id').
      order('projects.name, client_areas.name') }

  delegate :client, to: :project

  def all_locations
    subtree_location_client_areas = LocationClientArea.where client_area_id: self.subtree_ids
    return Location.none if subtree_location_client_areas.empty?
    Location.where("id IN (#{subtree_location_client_areas.map(&:location_id).join(',')})")
  end

  def string_id
    "#{id.to_s}"
  end

  def full_name
    "#{self.project.name} - #{self.name}"
  end
end
