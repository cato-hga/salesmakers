require 'rails_helper'

RSpec.describe Area, :type => :model do

  describe 'Validations' do
    before(:each) do
      @area = FactoryGirl.build :von_east_retail_region_area
    end

    it 'should have a name more than 3 characters long' do
      @area.name = 'ab'
      should_not be_valid
    end

    it 'should have an area type' do
      @area.area_type = nil
      should_not be_valid
    end
  end
end
