require 'apis/groupme'

class GroupMeGroup < ActiveRecord::Base
  has_and_belongs_to_many :group_me_users, join_table: :group_me_groups_group_me_users
  belongs_to :area
  has_many :group_me_posts

  def self.update_group(group_me_group_num)
    groupme = GroupMe.new_global
    group_json = groupme.get_group group_me_group_num
    return nil unless group_json
    group_me_group = GroupMeGroup.find_by group_num: group_json['id']
    if group_me_group
      group_me_group.update name: group_json['name'],
                            avatar_url: (group_json['avatar_url']) ? group_json['avatar_url'] : nil
    else
      group_me_group = GroupMeGroup.create name: group_json['name'],
                                           avatar_url: group_json['avatar_url'],
                                           group_num: group_me_group_num
    end
    return unless group_me_group and group_json['members']
    group_users = Array.new
    for member in group_json['members'] do
      group_me_user = GroupMeUser.return_group_me_user member['user_id'],
                                                       member['nickname'],
                                                       (member['image_url'] ? member['image_url'] : nil )
      group_users << group_me_user if group_me_user and not group_me_group.group_me_users.include?(group_me_user)
    end
    group_me_group.group_me_users << group_users
  end

  def likes_threshold
    member_count = self.group_me_users.count
    if member_count < 10
      4
    elsif member_count < 20
      5
    else
      6
    end
  end
end
