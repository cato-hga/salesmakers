# == Schema Information
#
# Table name: comcast_group_me_bots
#
#  id         :integer          not null, primary key
#  group_num  :string           not null
#  bot_num    :string           not null
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe ComcastGroupMeBot do
  subject { build :comcast_group_me_bot }

  it 'does not allow duplicate bot_num' do
    subject.save
    new_bot = build :comcast_group_me_bot, group_num: '88776655'
    expect(new_bot).not_to be_valid
  end
end
