module Groupme
  module Groups
    def get_first_group
      doGet '/groups', { per_page: 1 }
    end

    def get_groups
      doGet '/groups', { per_page: 100 }
    end

    def create_group(name, area = nil, image_url = 'https://i.groupme.com/1127x1127.png.51d265a13ce44925aaa15a4e6a2b7b0e')
      new_group = {
          name: name,
          description: 'SalesMakers, Inc.',
          image_url: image_url
      }.to_json
      response = doPost '/groups', new_group
      return nil unless response and response['response']
      GroupMeGroup.return_from_json response['response'], area
    end

    def rename_group(group_id, new_name)
      rename = {
          name: new_name
      }.to_json
      response = doPost "/groups/#{group_id}/update", rename

      if response and
          response['response'] and
          response['response']['name'] == new_name
        return true
      else
        return false
      end
    end

    def get_group(group_id)
      begin
        response = doGet '/groups/' + group_id
        return nil unless response and response['response']
      rescue JSON::ParserError
        return nil
      end
      response['response']
    end

    def add_to_group_by_user_id(group_id, nickname, user_id)
      add_user = {
          members: [
              {
                  nickname: nickname,
                  user_id: user_id
              }
          ]
      }.to_json
      doPost "/groups/#{group_id}/members/add", add_user
    end

    def remove_from_group_by_user_id group_id, user_id
      return if user_id == '12486363'
      group_json = get_group group_id || return
      members = group_json['members'] || return
      matching = members.find { |hash| hash['user_id'] == user_id } || return
      membership_id = matching['id'] || return
      doPost "/groups/#{group_id}/members/#{membership_id}/remove", {}.to_json
    end

    def move_all_members_from_group_to_group old_group_id, new_group_id
      old_group_json = get_group old_group_id || return
      new_group_json = get_group new_group_id || return
      old_group_members = old_group_json['members'] || return
      for member in old_group_members do
        nickname = member['nickname'] || next
        user_id = member['user_id'] || next
        membership_id = member['id'] || next
        add_to_group_by_user_id new_group_id, nickname, user_id
        next if user_id == '12486363'
        doPost "/groups/#{old_group_id}/members/#{membership_id}/remove", {}.to_json
      end
      get_group new_group_id
    end

    def add_all_members_from_one_group_to_another old_group_id, new_group_id
      old_group_json = get_group old_group_id || return
      old_group_members = old_group_json['members'] || return
      for member in old_group_members do
        nickname = member['nickname'] || next
        user_id = member['user_id'] || next
        add_to_group_by_user_id new_group_id, nickname, user_id
      end
      get_group new_group_id
    end

    def change_nickname_in_group group_id, nickname
      json = {
          "membership": {
              "nickname": nickname
          }
      }.to_json
      doPost "/groups/#{group_id}/memberships/update", json
    end

    def clean_groups
      groups = GroupMeGroup.all
      for group in groups do
        json = self.get_group group.group_num.to_s
        next unless json.blank?
        group.destroy
      end
    end
  end
end