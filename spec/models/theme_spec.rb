require 'rails_helper'

RSpec.describe Theme, :type => :model do

  before(:each) do
    @theme = FactoryGirl.build :dark_theme
  end

  subject { @theme }

  describe 'validations' do
    it 'should require a name at least 2 characters long' do
      @theme.name = nil
      should_not be_valid
      @theme.name = 'a'
      should_not be_valid
    end

    it 'should require a display name at least 2 characters long' do
      @theme.display_name = nil
      should_not be_valid
      @theme.display_name = 'a'
      should_not be_valid
    end
  end
end
