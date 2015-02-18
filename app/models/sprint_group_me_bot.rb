class SprintGroupMeBot < ActiveRecord::Base
  validates :group_num, presence: true
  validates :bot_num, presence: true, uniqueness: true
  validates :area_id, presence: true

  belongs_to :area
end
