require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMePost, :type => :model do

  it { should belong_to(:group_me_user) }
  it { should belong_to(:group_me_group) }
  it { should have_many(:group_me_likes) }
  it { should belong_to(:person) }

  #TODO: Test before_save :set_person
end
