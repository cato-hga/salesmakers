class ApplicationController < ActionController::Base
  include SentientController

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user, :get_projects
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_current_user
    @current_person = Person.find_by_email session[:cas_user] if session[:cas_user]
  end

  def current_user
    @current_person
  end

  def get_projects
    # TODO: Load projects based on Position
    @projects = Project.all
  end

  def current_theme
    # current_theme = 'dark'
  end

  helper_method :current_user
  helper_method :current_theme
end
