require 'rails_helper'

RSpec.describe TrainingTimeSlot, :type => :model do

  describe 'validations' do
    let(:time_slot) { build :training_time_slot, tuesday: true }
    it 'requires a training class type' do
      time_slot.training_class_type = nil
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

    end

  end
end
