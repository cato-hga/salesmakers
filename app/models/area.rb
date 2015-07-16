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

  after_save :deactivate_location_areas_if_inactive

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

  def all_location_areas
    LocationArea.where area_id: self.subtree_ids
  end

  def string_id
    "#{id.to_s}"
  end

  def full_name
    "#{self.project.name} - #{self.name}"
  end

  def direct_manager
    person_areas = self.person_areas.joins(:person).where("people.active = true AND person_areas.manages = true")
    return person_areas.first.person unless person_areas.empty?
    parent_area = self.parent
    until parent_area.nil? || !person_areas.empty?
      person_areas = parent_area.person_areas.joins(:person).where("people.active = true AND person_areas.manages = true")
      parent_area = parent_area.parent
    end
    person_areas.empty? ? nil : person_areas.first.person
  end

  private

  def deactivate_location_areas_if_inactive
    return if self.active?
    for location_area in self.all_location_areas do
      location_area.update active: false
    end
  end
end