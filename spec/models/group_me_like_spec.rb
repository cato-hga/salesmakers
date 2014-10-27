require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeLike, :type => :model do
  it { should belong_to(:group_me_post) }
  it { should belong_to(:group_me_user) }

  #TODO: Test create_from_json
  #TODO: Test like
  describe 'liking' do
    let(:group_me_user) { create :group_me_user }
    let(:group_me_post) { create :group_me_post }

    it 'should increase the like count' do
      expect{
        like = GroupMeLike.like group_me_user, group_me_post
        group_me_post.reload
      }.to change(group_me_post.group_me_likes, :count).by(2)
    end
  end
end
