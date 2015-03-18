class TrainingClassType < ActiveRecord::Base

  validates :project_id, presence: true
  validates :name, presence: true

  belongs_to :project

  def self.policy_class
    TrainingPolicy
  end
end
