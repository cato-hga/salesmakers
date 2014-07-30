require 'rails_helper'

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
    before(:all) do
      create :person, email: 'test@rbd-von.com', connect_user_id: '123456'
      create :person, email: 'test2@rbd-von.com', connect_user_id: nil
    end

    let(:person) { build_stubbed :person }

    it 'should allow multiple null values for connect_user_id' do
      expect(person).to be_valid
    end

    it 'should not allow duplicate not null values for connect_user_id' do
      person.connect_user_id = '123456'
      expect(person).not_to be_valid
    end

    it 'should not allow duplicate values for email' do
      person.email = 'test@rbd-von.com'
      expect(person).not_to be_valid
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
      person.office_phone = 7274985180
      should be_valid
      person.office_phone = nil
      person.mobile_phone = 5555555555
      should be_valid
      person.mobile_phone = nil
      person.home_phone = 5565565566
      should be_valid
    end
  end
end
