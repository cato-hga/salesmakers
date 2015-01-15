require 'rails_helper'

describe CommunicationLogEntry do
  subject { build :communication_log_entry }

  it 'saves when all required fields are present' do
    expect(subject).to be_valid
  end

  it 'requires a loggable' do
    subject.loggable = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

end