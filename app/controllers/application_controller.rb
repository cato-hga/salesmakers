class ApplicationController < ActionController::Base
  include SentientController
  include Pundit

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user, :get_projects
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  protected

  def setup_new_publishables
    @text_post = TextPost.new
    @uploaded_image = UploadedImage.new
    @uploaded_video = UploadedVideo.new
  end

  private

  def set_current_user
    @current_person = Person.find_by_email session[:cas_user] if session[:cas_user] #ME
    ##@current_person = Person.find_by_email 'kschwartz@retaildoneright.com' #TL
    #@current_person = Person.find_by_email 'zmirza@retaildoneright.com' #ASM
    #@current_person = Person.find_by_email 'mrenteria@retaildoneright.com' #RM
  end

  def current_user
    @current_person
  end

  def get_projects
    @projects = Project.all
  end

  def current_theme
    if @current_person and @current_person.profile and @current_person.profile.theme_name
      return @current_person.profile.theme_name
    end
    nil
  end

  helper_method :current_user
  helper_method :current_theme

  def permission_denied
    flash[:error] = 'You are not authorized to perform that action'
    unless request.env['HTTP_REFERER']
      redirect_to '/'
    else
      redirect_to :back
    end
  end
end
