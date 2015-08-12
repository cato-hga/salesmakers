class ApplicationController < BaseApplicationController
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_invalid_token

  before_action CASClient::Frameworks::Rails::Filter
  before_action :set_current_user,
                :check_active,
                #:setup_default_walls,
                #:set_last_seen,
                #:set_last_seen_profile,
                #:setup_new_publishables,
                #:filter_groupme_access_token,
                :setup_accessibles,
                :set_unseen_changelog_entries,
                :log_additional_data,
                :authorize_profiler

  protected

  def redirect_invalid_token
    render file: File.join(Rails.root, 'public/422.html'), status: 422, layout: false
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

  def log_additional_data
    request.env["exception_notifier.exception_data"] = {
        person: @person
    }
  end

  private

  def authorize_profiler
    dev = Position.find_by name: 'Software Developer'
    sdev = Position.find_by name: 'Senior Software Developer'
    if @current_person and (@current_person.position == dev or @current_person.position == sdev)
      Rack::MiniProfiler.authorize_request
    end
  end

  def set_comcast_locations
    comcast = Project.find_by name: 'Comcast Retail'
    return Location.none unless comcast
    @comcast_locations = comcast.locations_for_person @current_person
  end

  def set_directv_locations
    directv = Project.find_by name: 'DirecTV Retail'
    return Location.none unless directv
    @directv_locations = directv.locations_for_person @current_person
  end

  def current_person_has_position?
    @current_person and @current_person.position
  end

  def setup_accessibles
    def setup_accessibles
      if @current_person
        @visible_people_ids = Rails.cache.fetch(cached_visible_people_key) do
          @visible_people_ids = Person.visible(@current_person).ids
        end
        @visible_projects = Project.visible(@current_person)
      else
        @visible_people_ids = []
        @visible_projects = Project.none
      end
      @global_search = params[:global_search]
    end

    def cached_visible_people_key
      key = @current_person.id.to_s
      key += '-' + (@current_person.person_areas.empty? ? '' : @current_person.person_areas.maximum(:updated_at).try(:to_s, :number))
      key + '-' + @current_person.updated_at.try(:to_s, :number)
      end

    # if @current_person
    #   if session[:last_visibility_check] and session[:last_visibility_check] > 30.minutes.ago
    #     @visible_people ||= session[:visible_people]
    #     @visible_projects ||= session[:visible_projects]
    #     @visible_changelogs ||= session[:visible_logs]
    #   else
    #     session[:visible_people] = Person.visible(@current_person)
    #     @visible_people = session[:visible_people]
    #     session[:visible_projects] = Project.visible(@current_person)
    #     @visible_projects = session[:visible_projects]
    #     session[:visible_logs] = ChangelogEntry.visible(@current_person)
    #     @visible_changelogs = session[:visible_logs]
    #     session[:last_visibility_check] = Time.now
    #   end
    # else
    #   @visible_people ||= Person.none
    #   @visible_projects ||= Project.none
    #   @visible_changelogs ||= ChangelogEntry.none
    # end
    # @global_search = params[:global_search]
  end

  def set_unseen_changelog_entries
    @unseen_changelog_entries = ChangelogEntry.none
    return unless @current_person
    changelog_entry_id = @current_person.changelog_entry_id
    if changelog_entry_id
      @unseen_changelog_entries = ChangelogEntry.where('id > ?', changelog_entry_id).
          visible(@current_person)

    else
      @unseen_changelog_entries = ChangelogEntry.where('released >= ?', Time.now - 1.week).
          visible(@current_person)
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
    @current_person ||= Person.find_by_email session[:cas_user] if session[:cas_user] #ME
    #@current_person = Person.find_by_email 'mvallejojr@retaildoneright.com'
    if not @current_person and not Rails.env.test?
      st = self.session[:cas_last_valid_ticket]
      CASClient::Frameworks::Rails::Filter.client.ticket_store.cleanup_service_session_lookup(st) if st
      self.reset_session
      render(:file => File.join(Rails.root, 'public/good_cas_bad_person.html'), :status => 403, :layout => false) and return false
    else
      position = @current_person ? @current_person.position : nil
      @permission_keys = position ? position.permissions.select(:key).pluck(:key) : []
      @current_person
    end
  end

  def current_user
    @current_person
  end

  def check_active
    if @current_person and not @current_person.active?
      raise ActionController::RoutingError.new('Forbidden')
    end
  end

  helper_method :current_user
  helper_method :current_theme
end
