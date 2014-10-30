require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeUser, :type => :model do

  it { should have_and_belong_to_many :group_me_groups }
  it { should belong_to :person }
  it { should have_many :group_me_posts }
  it { should have_many :group_me_likes }

  describe 'find_or_create_from_json method' do

    json =
    it 'should create a Group Me User (or find one) from provided JSON' do

    end
  end

  describe 'return_group_me_user method' do

    it 'should return an existing user if an existing users person exists' do

    end
  end
end
