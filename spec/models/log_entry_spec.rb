require 'rails_helper'

RSpec.describe LogEntry, :type => :model do

  describe 'Validations' do

    before(:each) do
      @log_entry = FactoryGirl.build :create_person_log_entry
    end

    subject { @log_entry }

    it 'should require a person' do
      @log_entry.person = nil
      should_not be_valid
    end

    it 'should have an action' do
      @log_entry.action = nil
      should_not be_valid
    end

    it 'should reference a trackable' do
      @log_entry.trackable = nil
      should_not be_valid
    end
  end
end
