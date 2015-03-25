class AreaCandidateSourcingGroup < ActiveRecord::Base
  validates :name, presence: true
  validates :project, presence: true

  belongs_to :project
end
