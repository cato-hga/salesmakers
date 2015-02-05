require 'rails_helper'

describe Shift do
  subject { build :shift }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'requires hours' do
    subject.hours = nil
    expect(subject).not_to be_valid
  end
end