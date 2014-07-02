require 'rails_helper'

RSpec.describe DeviceDeployment, :type => :model do

  describe 'Validations' do

    before(:each) do
      @device_deployment = FactoryGirl.build :device_deployment
    end

    subject { @device_deployment }

    it 'should require a device_id' do
      @device_deployment.device_id = nil
      should_not be_valid
    end

    it 'should require a person' do
      @device_deployment.person = nil
      should_not be_valid
    end

    it 'should require a start date' do
      @device_deployment.started = nil
      should_not be_valid
    end
  end
end
