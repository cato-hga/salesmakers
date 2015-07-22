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
  subject { build :candidate_sprint_radio_shack_training_session }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a Candidate' do
    subject.candidate = nil
    expect(subject).not_to be_valid
  end

  it 'requires a SprintRadioShackTrainingSession' do
    subject.sprint_radio_shack_training_session = nil
    expect(subject).not_to be_valid
  end

  it 'requires a sprint_roster_status' do
    subject.sprint_roster_status = nil
    expect(subject).not_to be_valid
  end
end
