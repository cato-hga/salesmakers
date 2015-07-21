require 'rails_helper'

describe PersonPunch do
  subject { build :person_punch }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires an identifier' do
    subject.identifier = nil
    expect(subject).not_to be_valid
  end

  it 'requires a punch_time' do
    subject.punch_time = nil
    expect(subject).not_to be_valid
  end

  it 'requires an in_or_out value' do
    subject.in_or_out = nil
    expect(subject).not_to be_valid
  end

  it 'responds to person' do
    expect(subject).to respond_to :person
  end
end
