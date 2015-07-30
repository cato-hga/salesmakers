require 'rails_helper'

describe HistoricalLocationArea do
  subject { build :historical_location_area }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'requires a location' do
    subject.historical_location = nil
    expect(subject).not_to be_valid
  end

  it 'requires an area' do
    subject.historical_area = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end
end