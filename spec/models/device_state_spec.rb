require 'rails_helper'

RSpec.describe DeviceState, :type => :model do

  describe 'Validations' do

    before(:each) do
      @device_state = FactoryGirl.build :repair_device_state
    end

    subject { @device_state }

    it 'should have a name at least five characters long' do
      @device_state.name = 'abcd'
      should_not be_valid
    end
  end
end
