class GroupMeUser < ActiveRecord::Base
  has_and_belongs_to_many :group_me_groups
  belongs_to :person
  has_many :group_me_posts
end