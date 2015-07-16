require 'rails_helper'

describe RosterVerification do
  subject { build :roster_verification }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a creator' do
    subject.creator = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a status' do
    subject.status = nil
    expect(subject).not_to be_valid
  end

  it 'responds to last_shift_date' do
    expect(subject).to respond_to :last_shift_date
  end

  it 'responds to location' do
    expect(subject).to respond_to :location
  end

  it 'responds to envelope_guid' do
    expect(subject).to respond_to :envelope_guid
  end

  it 'requires a roster verification session' do
    subject.roster_verification_session = nil
    expect(subject).not_to be_valid
  end
end