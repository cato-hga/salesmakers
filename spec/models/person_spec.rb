require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Person, :type => :model do

  it do
    should ensure_length_of(:first_name).is_at_least(2)
    should ensure_length_of(:last_name).is_at_least(2)
    should ensure_length_of(:display_name).is_at_least(5)
    should allow_value('a@b.com').for(:email)
    should allow_value('a@b.com').for(:personal_email)
    should_not allow_value('a@b', 'ab.com').for(:email)
    should_not allow_value('a@b', 'ab.com').for(:personal_email)
    should allow_value('2134567890').for(:mobile_phone)
    should allow_value('2134567890').for(:office_phone)
    should allow_value('2134567890').for(:home_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:mobile_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:office_phone)
    should_not allow_value('1234567890', '24254', '0123456789').for(:home_phone)
  end


  describe 'uniqueness validations' do
    let(:person) { Person.first }
    let(:second_person) { create :person }

    it 'should allow multiple null values for connect_user_id' do
      person.connect_user_id = nil
      person.save
      second_person.connect_user_id = nil
      second_person.save
      expect(second_person).to be_valid
    end

    it 'should not allow duplicate not null values for connect_user_id' do
      person.connect_user_id = 123
      person.save
      second_person.connect_user_id = 123
      second_person.save
      expect(second_person).not_to be_valid
    end

    it 'should not allow duplicate values for email' do
      person.email = 'test@test.com'
      person.save
      second_person.email = 'test@test.com'
      second_person.save
      expect(second_person).not_to be_valid
    end

    it 'should not allow duplicate values for personal email' do
      person.personal_email = 'personal@test.com'
      person.save
      second_person.personal_email = 'personal@test.com'
      second_person.save
      expect(second_person).not_to be_valid
    end

    it 'should allow duplicate null values for personal email' do
      person.personal_email = nil
      person.save
      second_person.personal_email = nil
      second_person.save
      expect(second_person).to be_valid
    end

    it 'should allow duplicate values for first name and last name (combined)' do
      person.first_name = 'Test'
      person.last_name = 'Case'
      person.save
      second_person.first_name = 'Test'
      second_person.last_name = 'Case'
      second_person.save
      expect(second_person).to be_valid
    end

    it 'should not allow duplicate values for first name, last name, and a phone number (combined)' do
      person.first_name = 'Test'
      person.last_name = 'Case'
      person.mobile_phone = '8005551111'
      person.save
      second_person.first_name = 'Test'
      second_person.last_name = 'Case'
      second_person.mobile_phone = '8005551111'
      second_person.save
      expect(second_person).to be_valid
    end
  end

  describe 'phone number presence validation' do

    let(:person) { create :person }

    subject { person }

    it 'should require at least one phone number' do
      person.mobile_phone = nil
      person.office_phone = nil
      person.home_phone = nil
      should_not be_valid
      person.office_phone = '7274985180'
      should be_valid
      person.office_phone = nil
      person.mobile_phone = '5555555555'
      should be_valid
      person.mobile_phone = nil
      person.home_phone = '5565565566'
      should be_valid
    end

    it 'should clean the phone numbers' do
      person.mobile_phone = '716-415-8130'
      person.save
      expect(person.mobile_phone).to eq('7164158130')
    end

  end

  describe 'related members' do
    let(:person) { create :person }
    it 'should return team members' do
      expect(person.team_members).to_not be_nil
    end

    it 'should return department members' do
      expect(person.department_members).to_not be_nil
    end

    it 'should return all HQ members if person has all HQ visibility' do
      person.position.hq = true
      expect(Person.all_hq_members).to_not be_nil #TODO: Is this actually correct?
                                                  #I feel like i'm reading the reason for the method wrong
    end

    #TODO: Test all_field_members
  end

  #TODO: Test Returning from RBDC user
  # describe 'from RBDConnect' do
  #   let(:connect_user) { create :connect_user }
  #
  #   subject { connect_user }
  #
  #   it 'should return a person from connect user' do
  #     @connect_user = Person.return_from_connect_user(connect_user)
  #     expect(@connect_user.first_name).to eq('Steve')
  #   end
  # end


end
