class SessionsController < ApplicationController

  def destroy
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
