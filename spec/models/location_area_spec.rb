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

  describe '#head_count_full?' do
    it 'returns true if a location areas open head count is -1 or lower' do
      subject.target_head_count = 3
      subject.current_head_count = 2
      expect(subject.head_count_full?).to eq(false)
      subject.offer_extended_count = 2
      expect(subject.head_count_full?).to eq(true)
      subject.offer_extended_count = 3
      expect(subject.head_count_full?).to eq(true)
    end
  end
end