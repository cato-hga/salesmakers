require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeUser, :type => :model do

  it { should have_and_belong_to_many :group_me_groups }
  it { should belong_to :person }
  it { should have_many :group_me_posts }
  it { should have_many :group_me_likes }

  #TODO Test find_or_create_from_json
  #TODO Test return_group_me_user
end
