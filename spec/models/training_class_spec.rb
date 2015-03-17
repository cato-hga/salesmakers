require 'rails_helper'

RSpec.describe TrainingClass, :type => :model do

  describe 'validations' do
    let(:training) { build :training_class }
    it 'requires a training class type' do
      training.training_class_type_id = nil
      expect(training).not_to be_valid
    end
    it 'requires a time slot' do
      training.training_time_slot_id = nil
      expect(training).not_to be_valid
    end
    it 'requires a person' do
      training.person_id = nil
      expect(training).not_to be_valid
    end
    it 'requires a date' do
      training.date = nil
      expect(training).not_to be_valid
    end
  end
end
