require 'rails_helper'

RSpec.describe Department, :type => :model do


  describe 'Validations' do
    before(:each) do
      @department = FactoryGirl.build :von_retail_sales_department
    end

    subject { @department }

    it 'should work with valid parameters' do
      should be_valid
    end

    it 'should require a name at least 5 characters long' do
      @department.name = 'abcd'
      should_not be_valid
    end
  end
end
