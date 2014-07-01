class ApplicationController < ActionController::Base
  include SentientController

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_current_user
    @current_person = ConnectUser.find_by_username session[:cas_user] if session[:cas_user]
  end

  def current_user
    @current_person
  end

  helper_method :current_user
end
