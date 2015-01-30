require 'apis/groupme'
require 'apis/asset_shipping_notifier'

class GroupMeGroup < ActiveRecord::Base
  has_and_belongs_to_many :group_me_users, join_table: :group_me_groups_group_me_users
  belongs_to :area
  has_many :group_me_posts

  def self.update_group(group_me_group_num)
    groupme = GroupMe.new_global
    group_json = groupme.get_group group_me_group_num
    GroupMeGroup.update_group_via_json group_json
  end

  def self.update_group_via_json(group_json)
    return nil unless group_json
    group_me_group_num = group_json['id']
    group_me_group = GroupMeGroup.find_by group_num: group_json['id']
    if group_me_group
      GroupMeGroup.update_json group_me_group, group_json
    else
      group_me_group = GroupMeGroup.create_json group_json
    end
    GroupMeGroup.add_bot group_me_group
    return unless group_me_group and group_json['members']
    group_users = Array.new
    for member in group_json['members'] do
      group_me_user = GroupMeUser.return_group_me_user member['user_id'],
                                                       member['nickname'],
                                                       (member['image_url'] ? member['image_url'] : nil)
      group_users << group_me_user if group_me_user and not group_me_group.group_me_users.include?(group_me_user)
    end
    group_me_group.group_me_users << group_users
    GroupMeSubscription.new group_me_group_num
  end

  def self.update_json(group_me_group, group_json)
    group_me_group.update name: group_json['name'],
                          avatar_url: (group_json['avatar_url']) ? group_json['avatar_url'] : nil
    if group_me_group.area
      correct_name = GroupMeGroup.generate_group_name(group_me_group.area)
      if correct_name != group_me_group.name
        groupme = GroupMe.new_global
        groupme.rename_group group_me_group.group_num, correct_name
      end
    end
  end

  def self.generate_group_name(area)
    name_sub = area.name.gsub(/Sprint /, '')
    "[#{area.project.name}] #{name_sub}"
  end

  def self.create_json(group_json)
    group_me_group_num = group_json['id']
    GroupMeGroup.create name: group_json['name'],
                        avatar_url: group_json['avatar_url'],
                        group_num: group_me_group_num
  end

  def self.add_bot(group_me_group)
    return if group_me_group.bot_num
    groupme = GroupMe.new_global
    bot_num = groupme.add_bot('SalesCenter',
                              group_me_group.group_num,
                              'http://salesmakersinc.com/groupme/index.php')
    group_me_group.update bot_num: bot_num if bot_num
  end

  def self.return_from_json(group_json, area = nil)
    return nil unless group_json
    GroupMeGroup.find_or_create_by group_num: group_json['id'],
                                   area: area,
                                   name: group_json['name'],
                                   avatar_url: group_json['image_url']
  end

  # def likes_threshold
  #   member_count = self.group_me_users.count
  #   if member_count < 10
  #     4
  #   elsif member_count < 20
  #     5
  #   else
  #     6
  #   end
  # end

  def self.update_groups
    groupme = GroupMe.new_global
    groups = groupme.get_groups
    return unless groups and groups['response']
    groups = groups['response']
    for group in groups do
      GroupMeGroup.update_group_via_json group
    end
    GroupMeGroup.update_bots
  end

  def self.update_bots
    groupme = GroupMe.new_global
    bots = groupme.get_bots
    return unless bots and bots.count > 0
    add_bot_to = Array.new
    for group in GroupMeGroup.all do
      found_bot = false
      group_id = group.group_num.to_s
      for bot in bots do
        next unless bot['group_id'] and bot['name']
        bot_group_id = bot['group_id']
        bot_name = bot['name']
        found_bot = true if bot_group_id == group_id and bot_name == 'OneConnect'
      end
      unless found_bot
        groupme.add_bot 'SalesCenter',
                        group_id,
                        'https://one.rbdconnect.com/group_me_bot/message',
                        'https://i.groupme.com/1127x1127.png.51d265a13ce44925aaa15a4e6a2b7b0e'
      end
    end
  end

  def self.notify_of_assets(hours)
    notifier = AssetShippingNotifier.new
    notifier.process_movements(hours)
  end
end
