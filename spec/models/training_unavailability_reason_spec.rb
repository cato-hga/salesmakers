require 'rails_helper'

describe TrainingUnavailabilityReason do
  subject { build :training_unavailability_reason }

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'responds has_many training_availabilities' do
    expect(subject).to respond_to(:training_availabilities)
  end
end