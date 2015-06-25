# == Schema Information
#
# Table name: areas
#
#  id                               :integer          not null, primary key
#  name                             :string           not null
#  area_type_id                     :integer          not null
#  ancestry                         :string
#  created_at                       :datetime
#  updated_at                       :datetime
#  project_id                       :integer          not null
#  connect_salesregion_id           :string
#  personality_assessment_url       :string
#  area_candidate_sourcing_group_id :integer
#  email                            :string
#

class Area < ActiveRecord::Base
  extend AreaAssociationsModelExtension
  include AreaScopesModelExtension

  validates :name, presence: true, length: { minimum: 3 }
  validates :area_type, presence: true

  has_paper_trail
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

  def string_id
    "#{id.to_s}"
  end

  def full_name
    "#{self.project.name} - #{self.name}"
  end
end
