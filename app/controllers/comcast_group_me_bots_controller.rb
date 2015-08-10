require 'comcast_group_me_bot_callback'

class ComcastGroupMeBotsController < ApplicationController
  include GroupMeBotCallbackMessage

  skip_before_action CASClient::Frameworks::Rails::Filter,
                     :set_current_user
  protect_from_forgery except: :message

  def message
    handle_message(ComcastGroupMeBotCallback)
  end
end