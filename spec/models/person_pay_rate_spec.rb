require 'rails_helper'

describe PersonPayRate do
  subject { build :person_pay_rate }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a wage_type' do
    subject.wage_type = nil
    expect(subject).not_to be_valid
  end

  it 'requires a rate at least 7.50 or above' do
    subject.rate = 7.49
    expect(subject).not_to be_valid
  end

  it 'requires an effective_date' do
    subject.effective_date = nil
    expect(subject).not_to be_valid
  end
end