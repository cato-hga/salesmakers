class GroupMeGroup < ActiveRecord::Base
  has_and_belongs_to_many :group_me_users
  belongs_to :area
  has_many :group_me_posts
end
