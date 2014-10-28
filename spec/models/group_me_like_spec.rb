require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeLike, :type => :model do
  it { should belong_to(:group_me_post) }
  it { should belong_to(:group_me_user) }

  let(:group_me_user) { GroupMeUser.first  }
  let(:group_me_post) { GroupMePost.first }
  let(:like) { GroupMeLike.like group_me_user, group_me_post }
  let(:wall) { Wall.find_by_wallable_type 'Area' }

  describe 'creation from json' do
    it 'should parse JSON' do
      pending
    end
    it 'should increment the like count' do
      pending
    end
  end

  describe 'liking' do
    it 'should increase the like count' do
      expect{like}.to change(group_me_post.group_me_likes, :count).by(1)
    end

    it 'over likes threshold should create a Wall Post' do
      allow(group_me_post).to receive(:like_count).and_return(4)
      expect{like}.to change(WallPost, :count).by(1)
    end
  end
end
