class ApplicationController < ActionController::Base
  include SentientController
  include Pundit

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user,
                :check_active,
                :get_projects,
                :setup_default_walls,
                :set_last_seen,
                :setup_new_publishables,
                :filter_groupme_access_token,
                :setup_accessibles
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  protected

  def setup_new_publishables
    @text_post = TextPost.new
    @uploaded_image = UploadedImage.new
    @uploaded_video = UploadedVideo.new
    @link_post = LinkPost.new
    @wall_post_comment = WallPostComment.new
  end

  def setup_default_walls
    return unless @current_person and @current_person.position
    if @current_person.position.hq?
      @wall = Wall.find_by wallable: @current_person.position.department
    elsif @current_person.person_areas.count > 0
      @wall = Wall.find_by wallable: @current_person.person_areas.first.area
    else
      @wall = Wall.find_by wallable: @current_person
    end
    @walls = Wall.postable(@current_person).includes(:wallable)
  end

  private

  def setup_accessibles
    if @current_person
      @visible_walls = Wall.visible(@current_person).includes(:wallable)
      @visible_people = Person.visible(@current_person)
      @visible_projects = Project.visible(@current_person)
    else
      @visible_walls = Wall.none
      @visible_people = Person.none
      @visible_projects = Project.none
    end
  end

  def set_last_seen
    @seen_before = false
    return unless @current_person
    Person.record_timestamps = false
    @seen_before = @current_person.last_seen.present?
    @current_person.update last_seen: Time.now
    Person.record_timestamps = true
    WallPost.just_logged_in_post @current_person unless @seen_before
    WallPost.send_welcome_post @current_person unless @seen_before
  end

  def set_current_user
    @current_person = Person.find_by_email session[:cas_user] if session[:cas_user] #ME
    #@current_person = Person.find_by_email 'abegum@rbd-von.com' #Rep
    #@current_person = Person.find_by_email 'kschwartz@retaildoneright.com' #inactive
    #@current_person = Person.find_by_email 'amickens@retaildoneright.com' #TL
    #@current_person = Person.find_by_email 'zmirza@retaildoneright.com' #ASM
    #@current_person = Person.find_by_email 'mrenteria@retaildoneright.com' #RM
    #@current_person = Person.find_by_email 'sdesjarlais@retaildoneright.com' #Other Depart
    #@current_person = Person.find_by_email 'aschaker@rbd-von.com' #Other Rep
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

  def filter_groupme_access_token
    return unless @current_person and @current_person.groupme_access_token
    if @current_person.groupme_token_updated < Time.now - 60.days
      @current_person.update groupme_access_token: nil
    end
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
