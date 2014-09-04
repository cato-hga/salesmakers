class GroupMeLike < ActiveRecord::Base
  belongs_to :group_me_post
  belongs_to :group_me_user

  def self.create_from_json(json)
    group_me_user = GroupMeUser.find_by group_me_user_num: json['user_id']
    GroupMeGroup.update_group json['line']['group_id'] unless group_me_user
    group_me_message = GroupMePost.find_by message_num: json['line']['id']
    return nil unless group_me_user and group_me_message
    new_like = self.create group_me_user: group_me_user,
                           group_me_post: group_me_message

    group_me_message.increment! :like_count if new_like
  end
end
