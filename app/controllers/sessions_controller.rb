class SessionsController < ApplicationController

  def destroy
    session[:masquerade_as_email] = nil if session[:masquerade_as_email]
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
