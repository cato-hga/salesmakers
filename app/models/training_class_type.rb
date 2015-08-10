# == Schema Information
#
# Table name: training_class_types
#
#  id             :integer          not null, primary key
#  project_id     :integer          not null
#  name           :string           not null
#  ancestry       :string
#  max_attendance :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TrainingClassType < ActiveRecord::Base

  validates :project_id, presence: true
  validates :name, presence: true

  belongs_to :project

  def self.policy_class
    TrainingPolicy
  end
end
