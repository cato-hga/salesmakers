require 'rails_helper'

RSpec.describe Line, :type => :model do

  describe 'Validations' do
    before(:each) do
      @line = FactoryGirl.build :verizon_line
    end

    subject { @line }

    it 'should have an identifier at least 10 characters long' do
      @line.identifier = '123456789'
      should_not be_valid
    end

    it 'should require a contract end date' do
      @line.contract_end_date = nil
      should_not be_valid
    end

    it 'should require a technology service provider' do
      @line.technology_service_provider = nil
      should_not be_valid
    end

  end
end
