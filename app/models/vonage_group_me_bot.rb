# == Schema Information
#
# Table name: vonage_group_me_bots
#
#  id         :integer          not null, primary key
#  group_num  :string           not null
#  bot_num    :string           not null
#  area_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VonageGroupMeBot < ActiveRecord::Base
  validates :group_num, presence: true
  validates :bot_num, presence: true, uniqueness: true
  validates :area_id, presence: true

  belongs_to :area
end
