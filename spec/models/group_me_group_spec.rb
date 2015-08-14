# == Schema Information
#
# Table name: group_me_groups
#
#  id         :integer          not null, primary key
#  group_num  :integer          not null
#  area_id    :integer
#  name       :string           not null
#  avatar_url :string
#  created_at :datetime
#  updated_at :datetime
#  bot_num    :string
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe GroupMeGroup, :type => :model do

  it { should have_and_belong_to_many(:group_me_users) }
  it { should belong_to(:area) }
  it { should have_many(:group_me_posts) }

  describe '.update_group_via_json' do

    let(:group_me_group) { create :group_me_group }
    let!(:group_num) { group_me_group.group_num }
    let(:group_me_user) { create :group_me_user }
    let!(:user_id) { group_me_user.group_me_user_num }

    it 'should update the GroupMeGroup if GroupMeGroup is found' do
      json_info = {
          id: group_num,
          name: "New Name!",
          members: [{
                        user_id: user_id,
                        nickname: "Test",
                    }]
      }.to_json
      group_json = JSON.parse json_info
      GroupMeGroup.update_group_via_json group_json
      group_me_group.reload
      expect(group_me_group.name).to eq('New Name!')
    end

    # it 'should create the GroupMeGroup if GroupMeGroup is not found' do
    #   json_info = {
    #       id: "2",
    #       name: "New Name!",
    #       members: [{
    #                     user_id: user_id,
    #                     nickname: "Test",
    #                 }]
    #   }.to_json
    #   group_json = JSON.parse json_info
    #   expect {
    #     GroupMeGroup.update_group_via_json group_json
    #     group_me_group.reload
    #   }.to change(GroupMeGroup, :count).by(1)
    #
    # end
  end
#
#   describe '#likes_threshold' do
#     let(:group_me_group) { create :group_me_group }
#
#     it 'should return a likes threshold based upon the user count of a GroupMeGroup' do
#       expect(group_me_group.likes_threshold).to eq(4)
#       allow(group_me_group.group_me_users).to receive(:count).and_return(10)
#       expect(group_me_group.likes_threshold).to eq(5)
#       allow(group_me_group.group_me_users).to receive(:count).and_return(20)
#       expect(group_me_group.likes_threshold).to eq(6)
#     end
#   end
#

#   describe '.update_bots' do
#     pending
#   end
end
