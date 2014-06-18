require 'rails_helper'

RSpec.describe Position, :type => :model do

  describe 'Validations' do
    before(:each) do
      @position = FactoryGirl.build :von_retail_sales_specialist_position
    end

    subject { @position }

    it 'should work with valid parameters' do
      should be_valid
    end

    it 'should have a name at least 5 characters long' do
      @position.name = 'abcd'
      should_not be_valid
    end

    it 'should require a department' do
      @position.department = nil
      should_not be_valid
    end
  end
end
