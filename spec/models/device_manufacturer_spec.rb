require 'rails_helper'

RSpec.describe DeviceManufacturer, :type => :model do

  describe 'Validations' do

    before(:each) do
      @device_manufacturer = FactoryGirl.build :samsung_device_manufacturer
    end

    subject { @device_manufacturer }

    it 'should have a name longer than five characters' do
      @device_manufacturer.name = 'abcd'
      should_not be_valid
    end
  end
end
