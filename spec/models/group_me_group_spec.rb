require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeGroup, :type => :model do

  it { should have_and_belong_to_many(:group_me_users) }
  it { should belong_to(:area) }
  it { should have_many(:group_me_posts) }

  #TODO Test self.update_groups
  #TODO Test likes_threshold
end
