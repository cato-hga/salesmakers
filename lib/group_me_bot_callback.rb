class GroupMeBotCallback
  attr_accessor :group_id,
                :name,
                :system,
                :text,
                :user_id,
                :attachments

  def initialize(json)
    @callback_data = JSON.parse(json).inject({}){|data,(k,v)| data[k.to_sym] = v; data}
    return unless @callback_data[:text][0] == '!'
    set_values
  end

  def set_values
    self.group_id = @callback_data[:group_id]
    self.name = @callback_data[:name]
    self.system = @callback_data[:system]
    self.text = @callback_data[:text].downcase.sub('!', '')
    self.user_id = @callback_data[:user_id]
    self.attachments = @callback_data[:attachments]
  end

  def system?
    system
  end

end