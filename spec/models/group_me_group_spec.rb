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

describe GroupMeGroup do

  describe '.update_group_via_json', :vcr do
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
  end

end
