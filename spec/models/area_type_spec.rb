require 'rails_helper'

RSpec.describe AreaType, :type => :model do

  describe 'Validations' do

    before(:each) do
      @area_type = FactoryGirl.build :von_region_area_type
    end

    it 'should have a name at least three characters long' do
      @area_type.name = 'ab'
      should_not be_valid
    end

    it 'should have a project' do
      @area_type.project = nil
      should_not be_valid
    end
  end
end
