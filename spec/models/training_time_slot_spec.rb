require 'rails_helper'

RSpec.describe TrainingTimeSlot, :type => :model do

  describe 'validations' do
    let(:time_slot) { build :training_time_slot }
    it 'requires a training class type' do
      time_slot.training_class_type_id = nil
      expect(time_slot).not_to be_valid
    end
    it 'requires a start date' do
      time_slot.start_date = nil
      expect(time_slot).not_to be_valid
    end
    it 'requires an end date' do
      time_slot.end_date = nil
      expect(time_slot).not_to be_valid
    end
    it 'requires a person' do
      time_slot.person_id = nil
      expect(time_slot).not_to be_valid
    end
    it 'requires at least one day selected' do
      time_slot.monday = nil
      time_slot.tuesday = nil
      time_slot.wednesday = nil
      time_slot.thursday = nil
      time_slot.friday = nil
      time_slot.saturday = nil
      time_slot.sunday = nil
      expect(time_slot).not_to be_valid
      time_slot.monday = true
      expect(time_slot).to be_valid
    end
  end
end