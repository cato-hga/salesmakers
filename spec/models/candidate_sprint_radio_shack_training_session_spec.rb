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

require 'rails_helper'

describe CandidateSprintRadioShackTrainingSession do
end
