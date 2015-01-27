# require 'rails_helper'
# require 'shoulda/matchers'
#
# RSpec.describe GroupMeUser, :type => :model do
#
#   it { should have_and_belong_to_many :group_me_groups }
#   it { should belong_to :person }
#   it { should have_many :group_me_posts }
#   it { should have_many :group_me_likes }
#
#   describe '.find_or_create_from_json' do
#     let(:person) { create :person }
#     let(:group_me_user) { create :group_me_user }
#     let(:group_me_user_id) { group_me_user.group_me_user_num }
#     let(:json_info) { {
#         user_id: group_me_user_id,
#         name: 'Test',
#     }.to_json }
#     let(:json) { JSON.parse json_info }
#
#     it 'should create a Group Me User for a person from provided JSON' do
#       expect(person.group_me_user_id).not_to eq(group_me_user_id)
#       GroupMeUser.find_or_create_from_json(json, person)
#       group_me_user.reload
#       expect(person.group_me_user_id).to eq(group_me_user_id)
#     end
#   end
#
#   describe '.return_group_me_user' do
#     let(:person) { create :person, group_me_user_id: group_me_user_id }
#     let(:group_me_user) { create :group_me_user }
#     let(:group_me_user_id ) { group_me_user.group_me_user_num }
#
#     it 'should find the Person by their group_me_user_id'
#
#     it 'should create a GroupMeUser and return it if no existing user is found' do
#       expect{
#         GroupMeUser.return_group_me_user(group_me_user_id, 'Test')
#       }.to change(GroupMeUser, :count).by(1)
#     end
#   end
# end
