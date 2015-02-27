require 'uri'
require 'open-uri'
require 'fileutils'

class GroupMe
  include HTTParty
  base_uri 'https://api.groupme.com/v3'
  format :json

  def initialize(access_token)
    @access_token = access_token
  end

  def self.new_global
    self.new '1956b1d08a050132df253a66af516754'
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
    response = doGet '/groups/' + group_id
    return nil unless response and response['response']
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
      limit = get_limit_from_run_count(max, run_count)
      query[:limit] = limit
      query[:before_id] = before if before
      response = doGet "/groups/#{group_id}/messages", query
      return unless good_messages_response?(response)
      all_messages = response['response']['messages']
      messages.concat get_message_batch(all_messages, group_name, minimum_likes)
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

  def back_up_images(group_id, group_name)
    messages = get_messages_before group_id, group_name
    return if messages.nil?
    until messages.count == 0
      urls = get_urls_from_messages(messages)
      download_url_batch(urls)
      messages = get_messages_before group_id, group_name, messages.last.message_id
      return if messages.nil?
    end
  end

  def get_urls_from_messages(messages)
    urls = Array.new
    for message in messages do
      url = message.image_url
      urls << url if url
    end
    urls.uniq!
  end

  def download_url_batch(urls)
    for url in urls do
      next if url.include?("text.rbdconnect.com") or url.include?("salesmakersinc.com")
      puts "Downloading #{url}"
      download_and_save_image(group_name_to_directory_name(group_name), url)
    end
  end

  def group_name_to_directory_name(group_name)
    encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => ''         # Use a blank for those replacements
    }
    group_name.encode(Encoding.find('ASCII'), encoding_options)
  end

  def download_and_save_image(directory, url)
    begin
      dir_string = "/tmp/GroupMe Image Backup/#{directory}"
      FileUtils.mkdir_p(dir_string)
      filename = File.basename(URI.parse(url).path)
      parts = filename.split '.'
      parts.insert(parts.length - 2)
      filename = parts.insert(parts.length - 2, parts.delete_at(parts.length - 1)).
      join('.')
      open("#{dir_string}/#{filename}", 'wb') do |file|
        open(url) do |uri|
          file.write uri.read
        end
      end
    rescue
      return
    end
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

  def destroy_bot(bot_id)
    payload = {
        bot_id: bot_id
    }.to_json
    doPost '/bots/destroy', payload
  end

  def add_bot(name, group_id, callback_url = nil, avatar_url =  'https://i.groupme.com/1127x1127.png.51d265a13ce44925aaa15a4e6a2b7b0e')
    new_bot = {
        bot: {
            name: name,
            group_id: group_id,
            callback_url: callback_url,
            avatar_url: avatar_url
        }
    }.to_json
    response = doPost '/bots', new_bot
    return nil unless response and
        response['response'] and
        response['response']['bot']
    response['response']['bot']['bot_id']
  end

  def post_messages_with_bot(messages, bot_id, image_url = nil)
    return unless messages and messages.count > 0 and bot_id
    count = 0
    for message in messages do
      count += 1
      sleep(0.1)
      payload = {
          'bot_id' => bot_id,
          'text' => message
      }
      if image_url and count == 1
        payload['attachments'] = [{
                                      'type' => 'image',
                                      'url' => image_url
                                  }]
      end
      payload = payload.to_json
      response  self.class.post '/bots/post', { body: payload }
    end
    response
  end

  def doGet(path, query = nil)
    query_hash = { token: @access_token }
    query_hash = query_hash.merge query if query
    self.class.get path, { query: query_hash, headers: { 'Content-Type' => 'application/json',
                                                         'Accept' => 'application/json' } }
  end

  def doPost(path, body, query = nil)
    query_hash = { token: @access_token }
    query_hash = query_hash.merge query if query
    self.class.post path, { body: body, query: query_hash, headers: { 'Content-Type' => 'application/json',
                                                                      'Accept' => 'application/json' } }
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

  #TODO: Review whether or not these need to be attr_accessor or reader/writer. I have set it to accessor during refactoring just to be safe
  attr_accessor :group_name, :author, :attachments, :avatar, :likes

  def initialize(group_name, author, attachments, text, created_at, likes, avatar, message_id = nil)
    @group_name = group_name
    @author = author
    @attachments = attachments
    @text = text
    @created_at = created_at
    @likes = likes
    @avatar = avatar
    @message_id = message_id
    # @powerups = GroupMePowerUps
  end

  def has_image?
    has_image = false
    for attachment in @attachments do
      has_image = true if attachment['type'] == 'image'
    end
    has_image
  end

  def image_url
    return nil unless has_image?
    for attachment in @attachments do
      return attachment['url'] if attachment['type'] == 'image'
    end
  end

  def text
    # GroupMeEmojiFilter.filter @text, attachments
    @text
  end

  def message_id
    @message_id
  end

  def created_at
    Time.at(@created_at).to_datetime
  end

  def <=> other
    other.created_at <=> self.created_at
  end

end