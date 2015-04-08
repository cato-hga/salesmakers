require 'sprint_group_me_bot_callback'

class SprintGroupMeBotsController < ApplicationController
  skip_before_action CASClient::Frameworks::Rails::Filter,
                     :set_current_user
  protect_from_forgery except: :message

  def message
    SprintGroupMeBotCallback.new(request.body.read).process
    render nothing: true
  end
end