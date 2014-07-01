require 'rails_helper'

RSpec.describe TechnologyServiceProvider, :type => :model do

  describe 'Validations' do
    before(:each) do
      @technology_service_provider = FactoryGirl.build :verizon_technology_service_provider
    end

    subject { @technology_service_provider }

    it 'should require a name at least three characters long' do
      @technology_service_provider.name = 'ab'
      should_not be_valid
    end

  end
end
