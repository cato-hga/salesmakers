class GroupMePost < ActiveRecord::Base
  belongs_to :group_me_user
  belongs_to :group_me_group
  has_many :group_me_likes
end
