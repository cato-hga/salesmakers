require 'rails_helper'
require 'shoulda/matchers'

#TODO: TESTS

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


  # describe 'uniqueness validations' do
  #   before(:all) do
  #     build_stubbed :person_one, email: 'test@rbd-von.com', connect_user_id: '123456'
  #     build_stubbed :person_two, email: 'test2@rbd-von.com', connect_user_id: nil
  #   end
  #
  #   let(:person) { person_two }
  #
  #   it 'should allow multiple null values for connect_user_id' do
  #     expect(person).to be_valid
  #   end
  #
  #   it 'should not allow duplicate not null values for connect_user_id' do
  #     person_two.connect_user_id = '123456'
  #     expect(person).not_to be_valid
  #   end
  #
  #   it 'should not allow duplicate values for email' do
  #     person.email = 'test@rbd-von.com'
  #     expect(person).not_to be_valid
  #   end
  # end

  describe 'phone number presence validation' do

    let(:person) { create :person }

    subject { person }

    it 'should require at least one phone number' do
      person.mobile_phone = nil
      person.office_phone = nil
      person.home_phone = nil
      should_not be_valid
      person.office_phone = 7274985180
      should be_valid
      person.office_phone = nil
      person.mobile_phone = 5555555555
      should be_valid
      person.mobile_phone = nil
      person.home_phone = 5565565566
      should be_valid
    end

    it 'should clean the phone numbers' do
      person.mobile_phone = '716-415-8130'
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
