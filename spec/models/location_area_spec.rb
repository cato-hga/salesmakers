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

  it 'responds to launch group number' do
    expect(subject).to respond_to(:launch_group)
  end

  describe '#head_count_full?' do
    let(:hours_at_location_location) { create :location }
    let!(:hours_at_location_location_area) { create :location_area, location: hours_at_location_location, target_head_count: 1 }
    let(:hours_at_location_candidate) { create :candidate, location_area: hours_at_location_location_area, person: hours_at_location_person }
    let(:hours_at_location_person) { create :person }
    let(:hours_at_location_shift) { create :shift, person: hours_at_location_person, date: Date.today - 6.days, hours: 8 }
    let!(:second_hours_at_location_shift) { create :shift, person: hours_at_location_person, date: Date.today - 5.days, hours: 8 }

    it 'counts a candidate if candidate has booked hours at the location within the past 7 days' do
      expect(hours_at_location_location_area.head_count_full?).to eq(false)
      hours_at_location_shift.update location: hours_at_location_location
      expect(hours_at_location_location_area.head_count_full?).to eq(true)
    end

    it 'does not count candidates twice' do
      hours_at_location_shift.update location: hours_at_location_location
      second_hours_at_location_shift.update location: hours_at_location_location
      expect(hours_at_location_location_area.head_count_full?).to eq(true)
      hours_at_location_location_area.update target_head_count: 2
      expect(hours_at_location_location_area.head_count_full?).to eq(false)
    end

    let(:recent_trainings_location) { create :location }
    let!(:recent_trainings_location_area) { create :location_area, location: recent_trainings_location, target_head_count: 0 }
    let(:recent_trainings_candidate) { create :candidate, location_area: recent_trainings_location_area, person: recent_trainings_person }
    let(:recent_trainings_person) { create :person }
    let(:recent_trainings_shift) { create :shift, person: recent_trainings_person, date: Date.today - 6.days, hours: 8, location: location }

    it 'counts a candidate if candidate is in the 4/20 to 5/18 trainings, and have booked any hours in the past 7 days (location independent)' do

    end
    it 'counts a candidate if candidate is in the 5/11 training, with candidate confirmed training session status'
    it 'does not count inactive candidates'
    it 'returns true if a location areas open head count is -1 or lower'

  end
end