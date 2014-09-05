class GroupMeLike < ActiveRecord::Base
  belongs_to :group_me_post
  belongs_to :group_me_user

  def self.create_from_json(json)
    group_me_user = GroupMeUser.find_by group_me_user_num: json['user_id']
    GroupMeGroup.update_group json['line']['group_id'] unless group_me_user
    group_me_message = GroupMePost.find_by message_num: json['line']['id']
    return nil unless group_me_user and group_me_message
    self.like group_me_user, group_me_message
  end

  def self.like(group_me_user, group_me_post)
    new_like = self.create group_me_user: group_me_user,
                           group_me_post: group_me_post

    group_me_post.increment! :like_count if new_like
    group_me_post.reload
    if group_me_post.like_count == group_me_post.group_me_group.likes_threshold and group_me_post.person and group_me_post.group_me_group.area
      publication = Publication.publish group_me_post, group_me_post.person
      WallPost.create_from_publication publication, Wall.fetch_wall(group_me_post.group_me_group.area)
    end
    group_me_post.reload
  end
end
