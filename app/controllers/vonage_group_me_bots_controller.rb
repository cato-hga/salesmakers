require 'vonage_group_me_bot_callback'

class VonageGroupMeBotsController < ApplicationController
  include GroupMeBotCallbackMessage

  skip_before_action CASClient::Frameworks::Rails::Filter,
                     :set_current_user
  protect_from_forgery except: :message

  def message
    handle_message(VonageGroupMeBotCallback)
  end
end

