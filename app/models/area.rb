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
#  active                           :boolean          default(TRUE), not null
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

  def find_group_me_groups
    return self.group_me_groups unless self.group_me_groups.empty?
    parent_group_me_groups = []
    parent_area = self.parent
    while parent_group_me_groups.empty? && parent_area do
      parent_group_me_groups = parent_area.group_me_groups
      parent_area = parent_area.parent
    end
    parent_group_me_groups
  end

  def group_me_group
    self.group_me_groups.empty? ? nil : self.group_me_groups.first
  end

  private

  def deactivate_location_areas_if_inactive
    return if self.active?
    for location_area in self.all_location_areas do
      location_area.update active: false
    end
  end
end
