require 'rails_helper'

RSpec.describe Project, :type => :model do

  describe 'Validations' do
    before(:each) do
      @project = FactoryGirl.build :von_retail_project
    end

    it 'should have a name at least 4 characters long' do
      @project.name = 'abc'
      should_not be_valid
    end

    it 'should require a client' do
      @project.client = nil
      should_not be_valid
    end
  end
end
