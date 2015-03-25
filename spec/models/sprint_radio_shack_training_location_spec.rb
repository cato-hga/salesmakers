require 'rails_helper'

RSpec.describe SprintRadioShackTrainingLocation, :type => :model do

  describe 'validations' do
    let(:location) { build :sprint_radio_shack_training_location }
    it 'requires a name' do
      location.name = nil
      expect(location).not_to be_valid
    end
    it 'requires a virtual choice' do
      location.virtual = nil
      expect(location).not_to be_valid
    end
    it 'requires a room' do
      location.room = nil
      expect(location).not_to be_valid
    end
  end
end
