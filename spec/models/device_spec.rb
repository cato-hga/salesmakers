require 'rails_helper'

RSpec.describe Device, :type => :model do

  describe 'Validations' do

    before(:each) do
      @device = FactoryGirl.build :samsung_galaxytab3_device
    end

    subject { @device }

    it 'should have a identifier at least 4 characters long' do
      @device.identifier = '123'
      should_not be_valid
    end

    it 'should have a serial number at least 6 characters long' do
      @device.serial = '12345'
      should_not be_valid
    end

    it 'should have a device model' do
      @device.device_model = nil
      should_not be_valid
    end
  end
end
