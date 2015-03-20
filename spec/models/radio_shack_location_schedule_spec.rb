require 'rails_helper'

RSpec.describe RadioShackLocationSchedule, :type => :model do

  describe 'validations' do
    let(:schedule) { build :radio_shack_location_schedule }
    it 'requires an active y/n' do
      schedule.active = nil
      expect(schedule).not_to be_valid
    end

    it 'requires a name' do
      schedule.name = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a monday hour amount' do
      schedule.monday = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a tuesday hour amount' do
      schedule.tuesday = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a wednesday hour amount' do
      schedule.wednesday = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a thursday hour amount' do
      schedule.thursday = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a friday hour amount' do
      schedule.friday = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a saturday hour amount' do
      schedule.saturday = nil
      expect(schedule).not_to be_valid
    end
    it 'requires a sunday hour amount' do
      schedule.sunday = nil
      expect(schedule).not_to be_valid
    end
  end
end
