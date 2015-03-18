require 'rails_helper'

describe LocationArea do
  subject { build :location_area }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'requires an area' do
    subject.area = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end

  describe 'active and inactive location areas' do
    it 'pulls only active LocationAreas' do
      subject.save
      create :location_area, active: false
      expect(LocationArea.all.count).to eq(1)
    end
  end
end