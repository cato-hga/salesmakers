require 'comcast_group_me_bot_callback'

class ComcastGroupMeBotsController < ApplicationController
  skip_before_action CASClient::Frameworks::Rails::Filter
  protect_from_forgery except: :message

  def message
    ComcastGroupMeBotCallback.new(request.body.read).process
    render nothing: true
  end
end