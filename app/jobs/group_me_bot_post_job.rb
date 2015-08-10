require 'apis/groupme'

class GroupMeBotPostJob < ActiveJob::Base
  queue_as :group_me

  def perform(messages, display_name, group_num, image_url = nil)
    group_me = GroupMe.new_global
    bot_name = "#{display_name} via SalesCenter 2.0"
    bot_id = group_me.add_bot bot_name, group_num
    group_me.post_messages_with_bot messages, bot_id, image_url
    group_me.destroy_bot bot_id
  end
end