require 'rails_helper'

RSpec.describe PermissionGroup, :type => :model do

  describe 'Validations' do

    before(:each) do
      @permission_group = FactoryGirl.build :people_permission_group
    end

    subject { @permission_group }

    it 'should have a name at least three characters long' do
      @permission_group.name = 'ab'
      should_not be_valid
    end
  end
end
