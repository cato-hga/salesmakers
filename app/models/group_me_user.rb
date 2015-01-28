class GroupMeUser < ActiveRecord::Base
  has_and_belongs_to_many :group_me_groups, join_table: :group_me_groups_group_me_users
  belongs_to :person
  has_many :group_me_posts
  has_many :group_me_likes

  def self.find_or_create_from_json(json, person = nil)
    return nil unless json
    if person and json['user_id']
      person.update group_me_user_id: json['user_id']
    end
    self.return_group_me_user json['user_id'], json['name'], ((json['image_url']) ? json['image_url'] : nil), person
  end

  def self.return_group_me_user(group_me_user_num, name, avatar_url = nil, person = nil)
    existing_user = GroupMeUser.find_by group_me_user_num: group_me_user_num
    if existing_user
      existing_user.person = person if person
      return existing_user
    end
    unless person
      person = Person.find_by group_me_user_id: group_me_user_num
    end
    GroupMeUser.create group_me_user_num: group_me_user_num,
                       person: person,
                       name: name,
                       avatar_url: avatar_url

  end
end