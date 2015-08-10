# == Schema Information
#
# Table name: candidate_sprint_radio_shack_training_sessions
#
#  id                                     :integer          not null, primary key
#  candidate_id                           :integer          not null
#  sprint_radio_shack_training_session_id :integer          not null
#  sprint_roster_status                   :integer          default(0), not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#

class CandidateSprintRadioShackTrainingSession < ActiveRecord::Base
  validates :candidate, presence: true
  validates :sprint_radio_shack_training_session, presence: true
  validates :sprint_roster_status, presence: true

  belongs_to :candidate
  belongs_to :sprint_radio_shack_training_session

  default_scope { order created_at: :desc }

  enum sprint_roster_status: [
           :roster_status_pending,
           :sprint_submitted,
           :sprint_confirmed,
           :sprint_rejected,
           :sprint_preconfirmed
       ]
end
