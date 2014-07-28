require 'rails_helper'

RSpec.describe Position, :type => :model do

  before(:each) do
    @position = FactoryGirl.build_stubbed :von_retail_sales_specialist_position
  end

  subject { @position }

  describe 'Validations' do

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

  describe 'Permissions' do

    it 'should accept new permissions' do
      expect {
        permission = FactoryGirl.create :person_edit_permission
        @position.permissions << permission
      }.to change(@position.permissions, :count).by(1)
    end
  end
end
