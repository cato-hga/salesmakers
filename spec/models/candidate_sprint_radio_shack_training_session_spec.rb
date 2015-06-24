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