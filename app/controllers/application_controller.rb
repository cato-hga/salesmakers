class ApplicationController < ActionController::Base
  #include SentientController
  include Pundit

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user,
                :additional_exception_data,
                :set_staging,
                :check_active,
                :get_projects,
                #:setup_default_walls,
                :set_unseen_changelog_entries,
                #:set_last_seen,
                #:set_last_seen_profile,
                #:setup_new_publishables,
                #:filter_groupme_access_token,
                :setup_accessibles
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  protected

  def additional_exception_data
    request.env["exception_notifier.exception_data"] = {
        current_person: @current_person
    }
  end

  def setup_new_publishables
    @text_post = TextPost.new
    @uploaded_image = UploadedImage.new
    @uploaded_video = UploadedVideo.new
    @link_post = LinkPost.new
    @wall_post_comment = WallPostComment.new
  end

  def setup_default_walls
    return unless current_person_has_position?
    @wall = @current_person.default_wall
    @walls = Wall.postable(@current_person).includes(:wallable)
  end

  def date_time_string
    Time.zone.now.strftime('%Y-%m-%d_%H-%M')
  end

  private

  def set_comcast_locations
    comcast = Project.find_by name: 'Comcast Retail'
    return Location.none unless comcast
    @comcast_locations = comcast.locations_for_person @current_person
  end

  def current_person_has_position?
    @current_person and @current_person.position
  end

  def setup_accessibles
    if @current_person
      @visible_people = Person.visible(@current_person)
      @visible_projects = Project.visible(@current_person)
    else
      @visible_people = Person.none
      @visible_projects = Project.none
    end
  end

  def set_unseen_changelog_entries
    @unseen_changelog_entries = ChangelogEntry.none
    return unless @current_person
    changelog_entry_id = @current_person.changelog_entry_id
    if changelog_entry_id
      @unseen_changelog_entries = ChangelogEntry.visible(@current_person).
          where('id > ?',
                changelog_entry_id)
    else
      @unseen_changelog_entries = ChangelogEntry.visible(@current_person).
          where('released >= ?',
                Time.now - 1.week)
    end
  end

  def set_last_seen
    @seen_before = false
    return unless @current_person
    Person.record_timestamps = false
    @seen_before = @current_person.last_seen.present?
    @current_person.update last_seen: Time.now
    Person.record_timestamps = true
  end

  def set_current_user
    @current_person = Person.find_by_email session[:cas_user] if session[:cas_user] #ME
    #@current_person = Person.find_by_email 'mgallenstein@retaildoneright.com'
  end

  def set_staging
    @staging = Rails.env == 'staging'
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


  helper_method :current_user
  helper_method :current_theme

  def permission_denied
    render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
  end
end
