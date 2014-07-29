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
  end


    #TODO: Finish refactoring these
    #
    # it 'should require at least one phone number' do
    #   @person.mobile_phone = nil
    #   @person.office_phone = nil
    #   @person.home_phone = nil
    #   should_not be_valid
    #   @person.office_phone = 7274985180
    #   should be_valid
    #   @person.office_phone = nil
    #   @person.mobile_phone = 5555555555
    #   should be_valid
    #   @person.mobile_phone = nil
    #   @person.home_phone = 5565565566
    #   should be_valid
    # end
    #
    # it 'should require valid phone numbers' do
    #   @person.mobile_phone = nil
    #   @person.office_phone = nil
    #   @person.home_phone = nil
    #   @person.mobile_phone = '12345678910'
    #   should_not be_valid
    #
    #   @person.mobile_phone = '1234567890'
    #   should_not be_valid
    #
    #   @person.mobile_phone = '1234567'
    #   should_not be_valid
    #
    #   @person.mobile_phone = '2120111234'
    #   should_not be_valid
    #
    #   @person.mobile_phone = nil
    #
    #   @person.office_phone = '12345678910'
    #   should_not be_valid
    #
    #   @person.office_phone = '1234567890'
    #   should_not be_valid
    #
    #   @person.office_phone = '1234567'
    #   should_not be_valid
    #
    #   @person.office_phone = '2120111234'
    #   should_not be_valid
    #
    #   @person.office_phone = nil
    #
    #   @person.home_phone = '12345678910'
    #   should_not be_valid
    #
    #   @person.home_phone = '1234567890'
    #   should_not be_valid
    #
    #   @person.home_phone = '1234567'
    #   should_not be_valid
    #
    #   @person.home_phone = '2120111234'
    #   should_not be_valid
    # end
end
