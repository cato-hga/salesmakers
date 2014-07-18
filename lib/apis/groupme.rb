class GroupMe
  include HTTParty
  base_uri 'https://api.groupme.com/v3'
  format :json

  def initialize
    @access_token = '7a853610f0ca01310e5a065d7b71239d'
  end

  def get_groups
    doGet '/groups'
  end

  def get_messages(group_id, group_name = nil)
    response = doGet "/groups/#{group_id}/messages"
    return nil unless response.success?
    return nil unless response['response'] and response['response']['messages']
    messages = Array.new
    for message in response['response']['messages'] do
      group_me_message = GroupMeMessage.new group_name, message['name'], message['attachments'], message['text'], message['created_at']
      messages << group_me_message
    end

    messages
  end

  def get_recent_messages(per_group = 5)
    groups = get_groups
    messages = Array.new
    for group in groups['response'] do
      group_messages = get_messages group['group_id'], group['name']
      next unless group_messages
      if group_messages.count <= per_group
        messages = messages.concat group_messages
      else
        messages = messages.concat group_messages[0..4]
      end
    end
    messages
  end


  def doGet(path, query = nil)
    query_hash = { token: @access_token }
    query_hash = query_hash.merge query if query
    self.class.get path, { query: query_hash, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'} }
  end

  def doPost(path, body, query = nil)
    query_hash = { token: @access_token }
    query_hash = query_hash.merge query if query
    self.class.post path, { body: body, query: query_hash, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'} }
  end

end

class GroupMeMessage

  include Comparable

  def initialize(group_name, author, attachments, text, created_at)
    @group_name = group_name
    @author = author
    @attachments = attachments
    @text = text
    @created_at = created_at
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

  def text
    @text
  end

  def created_at
    Time.at(@created_at).to_datetime
  end

  def <=> other
    other.created_at <=> self.created_at
  end
end