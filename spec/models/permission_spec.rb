require 'rails_helper'

RSpec.describe Permission, :type => :model do

  describe 'Validations' do

    before(:each) do
      @permission = FactoryGirl.build :person_edit_permission
    end

    subject { @permission }

    it 'should have a key at least 5 characters long' do
      @permission.key = 'abcd'
      should_not be_valid
    end

    it 'should have a description at least 10 characters long' do
      @permission.description = 'abcdefghi'
      should_not be_valid
    end

    it 'should have a permission group' do
      @permission.permission_group = nil
      should_not be_valid
    end
  end
end
