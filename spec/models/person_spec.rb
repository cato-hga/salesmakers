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

    it 'should require at least one phone number' do
      @person.mobile_phone = nil
      @person.office_phone = nil
      @person.home_phone = nil
      should_not be_valid
      @person.office_phone = 7274985180
      should be_valid
      @person.office_phone = nil
      @person.mobile_phone = 5555555555
      should be_valid
      @person.mobile_phone = nil
      @person.home_phone = 5565565566
      should be_valid
    end

    it 'should require valid phone numbers' do
      @person.mobile_phone = nil
      @person.office_phone = nil
      @person.home_phone = nil
      @person.mobile_phone = '12345678910'
      should_not be_valid

      @person.mobile_phone = '1234567890'
      should_not be_valid

      @person.mobile_phone = '1234567'
      should_not be_valid 
      
      @person.mobile_phone = '2120111234'
      should_not be_valid
      
      @person.mobile_phone = nil

      @person.office_phone = '12345678910'
      should_not be_valid

      @person.office_phone = '1234567890'
      should_not be_valid

      @person.office_phone = '1234567'
      should_not be_valid

      @person.office_phone = '2120111234'
      should_not be_valid

      @person.office_phone = nil

      @person.home_phone = '12345678910'
      should_not be_valid

      @person.home_phone = '1234567890'
      should_not be_valid

      @person.home_phone = '1234567'
      should_not be_valid

      @person.home_phone = '2120111234'
      should_not be_valid
    end
  end

  # TODO: Make importing tests work
  # describe 'Creation of a Person from ConnectUser' do
  #
  #   it 'should import a Person from ConnectUser' do
  #     connect_user = ConnectUser.find_by_username 'matt@retaildoneright.com'
  #     expect { Person.return_from_connect_user connect_user }.to change(Person, :count).by(1)
  #   end
  # end
end
