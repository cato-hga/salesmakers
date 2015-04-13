module GroupMeBotCallbackMessage
  def handle_message(callback_class)
    callback_class.new(request.body.read).process
    render nothing: true
  end
end