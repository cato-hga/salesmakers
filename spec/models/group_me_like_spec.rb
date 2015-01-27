# require 'rails_helper'
# require 'shoulda/matchers'
#
# describe GroupMeLike do
#   it { should belong_to(:group_me_post) }
#   it { should belong_to(:group_me_user) }
#
#
#   let(:group_me_user) { create :group_me_user }
#   let(:group_me_post) { create :group_me_post }
#   let(:like) { GroupMeLike.like group_me_user, group_me_post }
#   let!(:wall) { create :area_wall }
#
#   describe 'creation from json' do
#     let(:group_id) { create(:group_me_group).group_num }
#     let(:user_id) { group_me_user.group_me_user_num }
#     let(:post_id) { group_me_post.message_num }
#
#     it 'should increment the like count' do
#       json_info = {
#           user_id: user_id,
#           line: {
#               group_id: group_id,
#               id: post_id
#           }
#       }.to_json
#       json = JSON.parse json_info
#       expect{GroupMeLike.create_from_json(json)}.to change(GroupMeLike, :count).by(1)
#     end
#   end
#
#   describe 'liking' do
#     it 'should increase the like count' do
#       expect{like}.to change(group_me_post.group_me_likes, :count).by(1)
#     end
#
#     it 'over likes threshold should create a Wall Post' do
#       group_me_post.group_me_group.group_me_users << group_me_user
#       allow(group_me_post.group_me_group).to receive(:likes_threshold).and_return(4)
#       allow(group_me_post).to receive(:like_count).and_return(4)
#       expect{like}.to change(WallPost, :count).by(1)
#     end
#   end
#
# end
