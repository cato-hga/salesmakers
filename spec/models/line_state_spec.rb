require 'rails_helper'

RSpec.describe LineState, :type => :model do

  describe 'Validations' do

    before(:each) do
      @line_state = FactoryGirl.build :suspended_line_state
    end

    subject { @line_state }

    it 'should have a name at least five characters long' do
      @line_state.name = 'abcd'
      should_not be_valid
    end
  end
end
