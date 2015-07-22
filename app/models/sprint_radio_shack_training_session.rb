# == Schema Information
#
# Table name: sprint_radio_shack_training_sessions
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_date :date             not null
#  locked     :boolean          default(FALSE), not null
#

class SprintRadioShackTrainingSession < ActiveRecord::Base
  validates :name, presence: true
  validates :start_date, presence: true

  has_many :candidate_sprint_radio_shack_training_sessions
  has_many :candidates, through: :candidate_sprint_radio_shack_training_sessions

  default_scope { order :name }
end
