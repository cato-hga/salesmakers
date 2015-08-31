# == Schema Information
#
# Table name: area_candidate_sourcing_groups
#
#  id           :integer          not null, primary key
#  group_number :integer
#  project_id   :integer          not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AreaCandidateSourcingGroup < ActiveRecord::Base
  validates :name, presence: true
  validates :project, presence: true

  belongs_to :project

  strip_attributes
end
