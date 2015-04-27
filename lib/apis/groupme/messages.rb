require 'apis/groupme/group_me_api_message'

module Groupme
  module Messages
    def get_messages_before(group_id, group_name, before_id = nil)
      messages = Array.new
      query = { limit: 20 }
      query[:before_id] = before_id if before_id
      response = doGet "/groups/#{group_id}/messages", query
      return nil unless response.success?
      return nil unless response['response'] and response['response']['messages']
      all_messages = response['response']['messages']
      for message in all_messages do
        next if message['system'] == true
        group_me_message = new_message(group_name, message, 0)
        messages << group_me_message
      end
      messages
    end

    def get_messages(group_id, max = 5, group_name = nil, minimum_likes = 0)
      before = nil
      messages = []
      query = initialize_messages_query(max)
      run_count = 0
      (max.to_f / 100.to_f).ceil.times do
        message_run = get_message_run(group_name, group_id, query, run_count, max, before, minimum_likes) || []
        messages.concat message_run
        run_count += 1
      end
      messages
    end

    def get_message_batch(message_batch, group_name, minimum_likes)
      messages = []
      for message in message_batch do
        next if message['system'] == true
        likes = 0
        likes = message['favorited_by'].count if message['favorited_by']
        next if likes < minimum_likes
        group_me_message = new_message(group_name, message, likes)
        messages << group_me_message
        before = message['id']
      end
      messages
    end

    def new_message(group_name, message, likes)
      GroupMeApiMessage.new group_name,
                            message['name'],
                            message['attachments'],
                            message['text'],
                            message['created_at'],
                            likes,
                            message['avatar_url']
    end

    def initialize_messages_query(max)
      if max < 100
        { limit: max }
      else
        { limit: 100 }
      end
    end

    def get_limit_from_run_count(max, run_count)
      if max - (100 * run_count) > 100
        100
      elsif max < 100
        max
      else
        max - (100 * run_count)
      end
    end

    def good_messages_response?(response)
      return false unless response.success?
      return false unless response['response'] and
          response['response']['messages']
      true
    end

    def get_recent_messages(per_group = 5, minimum_likes = 0)
      groups = get_groups
      messages = Array.new
      for group in groups['response'] do
        group_messages = get_messages group['group_id'], per_group, group['name'], minimum_likes
        next unless group_messages
        if group_messages.count <= per_group
          messages = messages.concat group_messages
        else
          messages = messages.concat group_messages[0..4]
        end
      end
      messages
    end

    def send_message(group_id, message_text)
      group_me_message = {
          message: {
              source_guid: SecureRandom.uuid,
              text: message_text
          }
          # attachments: {
          #     type: attachment_type,
          #     url: attachment_url,
          # }
      }.to_json
      #Separate out attachments hash and put into group me message if an attachment exists
      response = doPost "/groups/#{group_id}/messages", group_me_message
      if response.success?
        group_me_message
      else
        nil
      end
    end

    private

    def get_message_run(group_name, group_id, query, run_count, max, before, minimum_likes)
      limit = get_limit_from_run_count(max, run_count)
      query[:limit] = limit
      query[:before_id] = before if before
      response = doGet "/groups/#{group_id}/messages", query
      return unless good_messages_response?(response)
      all_messages = response['response']['messages']
      get_message_batch(all_messages, group_name, minimum_likes)
    end
  end
end