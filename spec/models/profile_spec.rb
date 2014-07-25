require 'rails_helper'

RSpec.describe Profile, :type => :model do

  before(:each) do
    @profile = FactoryGirl.build :smiles_profile
  end

  subject { @profile }

  describe 'validations' do

    it 'should require a person' do
      @profile.person = nil
      should_not be_valid
    end

  end

end
