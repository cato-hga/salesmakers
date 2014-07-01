require 'rails_helper'

RSpec.describe DeviceModel, :type => :model do

  describe 'Validations' do
    before(:each) do
      @device_model = FactoryGirl.build :samsung_galaxytab3_device_model
    end

    subject { @device_model }

    it 'should have a name longer than five characters' do
      @device_model.name = 'abcd'
      should_not be_valid
    end

    it 'should require a device manufacturer' do
      @device_model.device_manufacturer_id = nil
      should_not be_valid
    end
  end
end
