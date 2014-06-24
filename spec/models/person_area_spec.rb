require 'rails_helper'

RSpec.describe PersonArea, :type => :model do

  describe 'Validations' do

    before(:each) do
      @person_area = FactoryGirl.build :von_retail_east_sales_specialist_person_area
    end

    subject { @person_area }

    it 'should require a person' do
      @person_area.person_id = nil
      should_not be_valid
    end

    it 'should require an area' do
      @person_area.area_id = nil
      should_not be_valid
    end
  end
end
