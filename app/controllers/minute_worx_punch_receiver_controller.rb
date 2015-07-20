class MinuteWorxPunchReceiverController < ApplicationController
layout false
protect_from_forgery except: :incoming

skip_before_action CASClient::Frameworks::Rails::Filter
skip_before_action :set_current_user,
                   :check_active,
                   :get_projects,
                   :setup_default_walls,
                   :set_last_seen,
                   :set_last_seen_profile,
                   :setup_new_publishables,
                   :filter_groupme_access_token,
                   :setup_accessibles,
                   :verify_authenticity_token

  def begin
    render nothing: true
  end

end