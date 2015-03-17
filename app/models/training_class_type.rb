class TrainingClassType < ActiveRecord::Base

  validates :project_id, presence: true
  validates :name, presence: true

  belongs_to :project
end
