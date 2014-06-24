require 'rails_helper'

RSpec.describe Person, :type => :model do

  describe 'Validations' do
    before(:each) do
      @person = FactoryGirl.build :von_retail_sales_specialist_person
    end

    subject { @person }

    it 'should work with valid parameters' do
      should be_valid
    end

    it 'should require a first name at least two characters long' do
      @person.first_name = 'a'
      should_not be_valid
    end

    it 'should require a last name at least two characters long' do
      @person.last_name = 'a'
      should_not be_valid
    end

    it 'should generate a display name at least 5 characters long' do
      @person.display_name = nil
      should be_valid
    end

    it 'should require a valid email address' do
      @person.email = 'a@b'
      should_not be_valid
      @person.email = 'ab.com'
      should_not be_valid
      @person.email = 'a@b.c'
      should_not be_valid
    end

    it 'should require a valid personal email address' do
      @person.personal_email = 'a@b'
      should_not be_valid
      @person.personal_email = 'ab.com'
      should_not be_valid
      @person.personal_email = 'a@b.c'
      should_not be_valid
    end

    it 'should require a position' do
      @person.position = nil
      should_not be_valid
    end
  end

  describe 'Creation of a Person from ConnectUser' do

    it 'should import a Person from ConnectUser' do
      connect_user = ConnectUser.find_by_username 'matt@retaildoneright.com'
      expect { Person.create_from_connect_user connect_user }.to change(Person, :count).by(1)
    end
  end
end
