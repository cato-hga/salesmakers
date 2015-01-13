require 'rails_helper'

describe SMSMessage do
  subject { build :sms_message }

  it 'is valid in its initial state' do
    expect(subject).to be_valid
  end

  it 'requires a from_num' do
    subject.from_num = nil
    expect(subject).not_to be_valid
  end

  it 'requires from_num to be 10 digits' do
    subject.from_num = '123456789'
    expect(subject).not_to be_valid
  end

  it 'requires a to_num' do
    subject.to_num = nil
    expect(subject).not_to be_valid
  end

  it 'requires to_num to be 10 digits' do
    subject.to_num = '123456789'
    expect(subject).not_to be_valid
  end

  it 'requires a message' do
    subject.message = nil
    expect(subject).not_to be_valid
  end

  it 'requires a sid' do
    subject.sid = nil
    expect(subject).not_to be_valid
  end
end