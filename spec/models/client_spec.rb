require 'rails_helper'

RSpec.describe Client, :type => :model do

  describe 'Validations' do
    before(:each) do
      @client = FactoryGirl.build :von_client
    end

    it 'should require a name at least two characters long' do
      @client.name = 'a'
      should_not be_valid
    end
  end
end
