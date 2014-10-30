class GroupMe
  include HTTParty
  base_uri 'https://api.groupme.com/v3'
  format :json

  def initialize(access_token)
    @access_token = access_token
  end

  def self.new_global
    self.new '7a853610f0ca01310e5a065d7b71239d'
  end

  def get_groups
    doGet '/groups', { per_page: 100 }
  end

  def get_group(group_id)
    response = doGet '/groups/' + group_id
    return nil unless response and response['response']
    response['response']
  end

  def get_messages(group_id, max = 5, group_name = nil, minimum_likes = 0)
    before = nil
    messages = Array.new
    if max < 100
      query = { limit: max }
    else
      query = { limit: 100 }
    end
    run_count = 0
    (max.to_f / 100.to_f).ceil.times do
      if max - (100 * run_count) > 100
        limit = 100
      elsif max < 100
        limit = max
      else
        limit = max - (100 * run_count)
      end
      query[:limit] = limit
      query[:before_id] = before if before
      response = doGet "/groups/#{group_id}/messages", query
      return nil unless response.success?
      return nil unless response['response'] and response['response']['messages']
      all_messages = response['response']['messages']
      for message in all_messages do
        next if message['system'] == true
        likes = 0
        likes = message['favorited_by'].count if message['favorited_by']
        next if likes < minimum_likes
        group_me_message = GroupMeApiMessage.new group_name, message['name'], message['attachments'], message['text'],
                                              message['created_at'], likes, message['avatar_url']
        messages << group_me_message
        before = message['id']
      end
      run_count += 1
    end
    messages
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

  def get_images(max = 10, filter_messages_per_group = 10)
    messages = get_recent_messages filter_messages_per_group
    urls = Array.new
    for message in messages do
      attachments = message.attachments
      for attachment in attachments do
        urls << attachment['url'] if attachment['type'] == 'image'
      end
      return urls[0..(max - 1)] if urls.count >= max
    end
    urls
  end

  def get_me
    response = doGet '/users/me'
    return response['response'] if response and response['response']
    nil
  end

  def get_bots
    response = doGet '/bots'
    return unless response and response['response']
    response['response']
  end

  def add_bot(name, group_id, callback_url = nil, avatar_url = nil)
    new_bot = {
        bot: {
            name: name,
            group_id: group_id,
            callback_url: callback_url,
            avatar_url: avatar_url
        }
    }.to_json
    doPost '/bots', new_bot
  end

  def doGet(path, query = nil)
    query_hash = { token: @access_token }
    query_hash = query_hash.merge query if query
    self.class.get path, { query: query_hash, headers: { 'Content-Type' => 'application/json',
                                                         'Accept' => 'application/json'} }
  end

  def doPost(path, body, query = nil)
    query_hash = { token: @access_token }
    query_hash = query_hash.merge query if query
    self.class.post path, { body: body, query: query_hash, headers: { 'Content-Type' => 'application/json',
                                                                      'Accept' => 'application/json'} }
  end

  def send_message(group_id, message_text)
    group_me_message =  {
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
    group_me_message
  end

end

class GroupMeEmojiFilter

  def self.filter(text, attachments)
    if attachments and attachments.count > 0 and GroupMePowerUps.count > 0
      for attachment in attachments do
        if attachment['type'] and attachment['type'] == 'emoji'
          pack_id = attachment['charmap'][0][0]
          powerup_id = attachment['charmap'][0][1]
          powerup_pack = GroupMePowerUps.find { |pack| pack['meta']['pack_id'] == pack_id }
          next unless powerup_pack
          inline = powerup_pack['meta']['inline'].find { |inline| inline['x'] == 20 }
          next unless inline
          image = inline['image_url']
          pixel_down = 20 * powerup_id * -1
          image_html = '<span style="'
          image_html += "background: url(#{image}) no-repeat left top;"
          image_html += "background-size: 20px auto !important;"
          image_html += "background-position: 0 #{pixel_down}px;"
          image_html += '" class="emoji"></span>'
          text.gsub! attachment['placeholder'], image_html
        end
      end
    end
    text
  end

end

class GroupMeApiMessage

  include Comparable

  def initialize(group_name, author, attachments, text, created_at, likes, avatar)
    @group_name = group_name
    @author = author
    @attachments = attachments
    @text = text
    @created_at = created_at
    @likes = likes
    @avatar = avatar
    @powerups = GroupMePowerUps
  end

  def group_name
    @group_name
  end

  def author
    @author
  end

  def attachments
    @attachments
  end

  def has_image?
    attachments and attachments.count > 0 and attachments[0]['type'] == 'image'
  end

  def text
    GroupMeEmojiFilter.filter @text, attachments
  end

  def created_at
    Time.at(@created_at).to_datetime
  end

  def likes
    @likes
  end

  def avatar
    @avatar
  end

  def <=> other
    other.created_at <=> self.created_at
  end

end