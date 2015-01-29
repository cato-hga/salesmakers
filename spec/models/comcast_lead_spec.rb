require 'rails_helper'

describe ComcastLead do
  subject { build :comcast_lead }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a comcast_customer_id' do
    subject.comcast_customer_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires at least one service selection' do
    subject.tv = false
    subject.internet = false
    subject.phone = false
    subject.security = false
    expect(subject).not_to be_valid
    subject.tv = true
    expect(subject).to be_valid
    subject.tv = false; subject.internet = true
    expect(subject).to be_valid
    subject.internet = false; subject.phone = true
    expect(subject).to be_valid
    subject.phone = false; subject.security = true
    expect(subject).to be_valid
  end

  it 'requires that the follow up date be in the future' do
    subject.follow_up_by = Date.today
    expect(subject).not_to be_valid
    subject.follow_up_by = Date.yesterday
    expect(subject).not_to be_valid
    subject.follow_up_by = Date.tomorrow
    expect(subject).to be_valid
  end
end