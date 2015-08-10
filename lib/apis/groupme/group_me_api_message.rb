class GroupMeApiMessage
  include Comparable

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