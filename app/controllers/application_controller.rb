class ApplicationController < ActionController::Base
  include SentientController
  include Pundit

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user, :check_active,  :get_projects, :setup_default_wall, :setup_new_publishables
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

  def setup_default_wall
    return unless @current_person and @current_person.position
    if @current_person.position.hq?
      @wall = Wall.find_by wallable: @current_person.position.department
    else
      @wall = Wall.find_by wallable: @current_person.person_areas.first.area
    end
  end

  private

  def set_current_user
    #@current_person = Person.find_by_email session[:cas_user] if session[:cas_user] #ME
    #@current_person = Person.find_by_email 'kschwartz@retaildoneright.com' #inactive
    @current_person = Person.find_by_email 'amickens@retaildoneright.com' #TL
    #@current_person = Person.find_by_email 'zmirza@retaildoneright.com' #ASM
    #@current_person = Person.find_by_email 'mrenteria@retaildoneright.com' #RM
    #@current_person = Person.find_by_email 'sdesjarlais@retaildoneright.com' #Other Depart
  end

  def current_user
    @current_person
  end

  def check_active
    if @current_person and not @current_person.active?
      raise ActionController::RoutingError.new('Forbidden')
    end
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
