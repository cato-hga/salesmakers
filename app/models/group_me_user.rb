class GroupMeUser < ActiveRecord::Base
  has_and_belongs_to_many :group_me_groups
  belongs_to :person
  has_many :group_me_posts

  def self.find_or_create_from_json(json, person = nil)
    return nil unless json
    if person and json['user_id']
      person.update group_me_user_id: json['user_id']
    end
    existing_user = GroupMeUser.find_by group_me_user_num: json['user_id']
    if existing_user
      existing_user.person = person if person
      return existing_user
    end
    GroupMeUser.create group_me_user_num: json['user_id'],
                       person: person,
                       name: json['name'],
                       avatar_url: (json['image_url']) ? json['image_url'] : nil

  end

end