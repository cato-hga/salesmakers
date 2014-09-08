require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeLike, :type => :model do
  it { should belong_to(:group_me_post) }
  it { should belong_to(:group_me_user) }

  #TODO: Test create_from_json
  #TODO: Test like
end
