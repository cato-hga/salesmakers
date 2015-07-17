require 'rails_helper'

describe RosterVerificationSession do
  subject { build :roster_verification_session }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a creator' do
    subject.creator = nil
    expect(subject).not_to be_valid
  end

  it 'responds to roster_verifications' do
    expect(subject).to respond_to :roster_verifications
  end

  it 'responds to missing_employees' do
    expect(subject).to respond_to :missing_employees
  end
end