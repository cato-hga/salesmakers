require 'apis/gateway'

class CandidatesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar, except: [:support_search]
  before_action :get_candidate, except: [:index, :support_search, :dashboard, :new, :create]
  before_action :setup_confirm_form_values, only: [:confirm, :record_confirmation, :edit_candidate_details, :update_candidate_details]
  before_action :get_suffixes_and_sources, only: [:new, :create, :edit, :update]

  layout 'candidates', except: [:support_search]
  layout 'application', only: [:support_search]

  def index
    @candidates = @search.result.page(params[:page])
  end

  def support_search
    if params[:enable_filter] == 'true'
      statuses = Candidate.statuses
      @search = Candidate.where("status >= 10").search(params[:q])
      @statuses = []
      for status in statuses do
        @statuses << status if status[1] >= 10
      end
    else
      statuses = Candidate.statuses
      @search = Candidate.where("status >= 8").search(params[:q])
      @statuses = []
      for status in statuses do
        @statuses << status if status[1] >= 8
      end
    end
    @candidates = @search.result.page(params[:page])
  end

  def dashboard
    set_datetime_range
    set_entered
    set_prescreened
    set_interview_scheduled
    set_accepted
    set_paperwork_sent
    set_paperwork_completed_by_candidate
    set_paperwork_completed_by_advocate
    set_paperwork_completed_by_hr
    set_onboarded
  end

  def show
    @candidate = Candidate.find params[:id]
    @candidate_contacts = @candidate.candidate_contacts
    @log_entries = @candidate.related_log_entries.page(params[:log_entries_page]).per(10)
    if @candidate.location_area and @candidate.location_area.location and @candidate.location_area.location.sprint_radio_shack_training_location
      @training_location = @candidate.location_area.location.sprint_radio_shack_training_location
    else
      @training_location = nil
    end
  end

  def new
    @candidate = Candidate.new
    @candidate_source = nil
    @call_initiated = DateTime.now.to_i
  end

  def create
    @candidate = Candidate.new candidate_params.merge(created_by: @current_person)
    @projects = Project.all
    @candidate_source = CandidateSource.find_by id: candidate_params[:candidate_source_id]
    @prescreen = params[:start_prescreen] == 'true' ? true : false
    if @candidate.save and @prescreen
      create_and_prescreen
    elsif @candidate.save
      create_without_prescreen
    else
      render :new
    end
  end

  def edit
    @candidate_source = @candidate.candidate_source
  end

  def update
    @candidate_source = @candidate.candidate_source
    if @candidate.update candidate_params
      @current_person.log? 'update',
                           @candidate
      flash[:notice] = 'Candidate updated'
      redirect_to candidate_path @candidate
    else
      flash[:notice] = 'Candidate could not be saved:'
      render :edit
    end
  end

  def dismiss
    @denial_reasons = CandidateDenialReason.where active: true
  end

  def reactivate
    if @candidate.update active: true
      reset_candidate_status
      @current_person.log? 'reactivate',
                           @candidate
      flash[:notice] = 'Candidate reactivated'
      redirect_to candidate_path @candidate
    else
      flash[:error] = 'Candidate could not be reactivated'
      render :show
    end
  end

  def destroy
    @selected_reason = params[:candidate][:candidate_denial_reason_id]
    @denial_reason = CandidateDenialReason.find_by id: @selected_reason
    if @selected_reason.blank?
      flash[:error] = 'Candidate denial reason can not be blank'
      render :dismiss and return
    end
    @interviews = InterviewSchedule.where(candidate_id: @candidate.id)
    if @interviews.any?
      for interview in @interviews
        interview.update active: false
      end
    end
    @candidate.update active: false, candidate_denial_reason: @denial_reason
    @current_person.log? 'dismiss',
                         @candidate,
                         @denial_reason
    flash[:notice] = 'Candidate dismissed'
    redirect_to candidates_path
  end

  def select_location
    all_location_areas = get_all_location_areas
    @location_area_search = all_location_areas.search(params[:q])
    @location_areas = order_by_distance(@location_area_search.result)
    @back_to_confirm = params[:back_to_confirm] == 'true' ? true : false
  end

  def set_location_area
    @location_area = LocationArea.find params[:location_area_id]
    @back_to_confirm = params[:back_to_confirm] == 'true' ? true : false
    previous_location_area = @candidate.location_area
    unless @candidate.update(location_area: @location_area)
      flash[:error] = @candidate.errors.full_messages.join(', ')
      redirect_to select_location_candidate_path(@candidate, @back_to_confirm.to_s) and return
    end
    if previous_location_area
      previous_location_area.update potential_candidate_count: previous_location_area.potential_candidate_count - 1
      if Candidate.statuses[@candidate.status] >= Candidate.statuses['accepted']
        previous_location_area.update offer_extended_count: previous_location_area.offer_extended_count - 1
      end
    end
    @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
    @candidate.location_selected! if @candidate.status == 'prescreened'
    flash[:notice] = 'Location chosen successfully.'
    if @back_to_confirm
      redirect_to confirm_candidate_path(@candidate)
    else
      CandidatePrescreenAssessmentMailer.assessment_mailer(@candidate, @location_area.area).deliver_later
      @current_person.log? 'sent_assessment',
                           @candidate
      redirect_to new_candidate_interview_schedule_path(@candidate)
    end
  end

  def confirm
    #just uses get_candidate
    @training_availability = TrainingAvailability.new
  end

  def record_confirmation
    @training_availability = TrainingAvailability.new
    if @shirt_gender.blank? or @shirt_size.blank?
      flash[:error] = 'You must select a shirt gender and size to proceed.'
      render :confirm and return
    end
    @training_availability.able_to_attend = @able_to_attend
    @training_availability.candidate = @candidate
    set_unable_to_attend_params unless @able_to_attend
    if @training_availability.save
      @candidate.shirt_size = params[:shirt_size]
      @candidate.shirt_gender = params[:shirt_gender]
      @candidate.save
      @current_person.log? 'confirmed',
                           @candidate
      @candidate.confirmed!
      if @candidate.active? and @candidate.job_offer_details.any?
        flash[:notice] = 'Confirmation recorded'
        redirect_to candidate_path @candidate
      elsif @candidate.active? and @candidate.passed_personality_assessment?
        redirect_to send_paperwork_candidate_path(@candidate)
      else
        flash[:notice] = 'Confirmation recorded. Paperwork will be sent when personality assessment is passed.'
        redirect_to candidate_path(@candidate)
      end
    else
      render :confirm
    end
  end

  def edit_candidate_details
    #get candidate
    @training_availability = @candidate.training_availability
  end

  def update_candidate_details
    @training_availability = @candidate.training_availability
    if @shirt_gender.blank? or @shirt_size.blank?
      flash[:error] = 'You must select a shirt gender and size to proceed.'
      render :edit_candidate_details and return
    end
    @training_availability.able_to_attend = @able_to_attend
    @training_availability.candidate = @candidate
    set_unable_to_attend_params unless @able_to_attend
    @candidate.shirt_size = params[:shirt_size]
    @candidate.shirt_gender = params[:shirt_gender]
    if @training_availability.save and @candidate.save
      @current_person.log? 'update',
                           @candidate
      flash[:notice] = 'Candidate updated'
      redirect_to candidate_path @candidate
    else
      flash[:error] = 'Candidate could not be updated'
      render :edit_candidate_details
    end
  end

  def send_paperwork
    geocode_if_necessary
    if Rails.env.staging?
      envelope_response = 'STAGING'
    else
      envelope_response = DocusignTemplate.send_nhp @candidate, @current_person
    end
    @candidate.job_offer_details.destroy_all
    job_offer_details = JobOfferDetail.new candidate: @candidate,
                                           sent: DateTime.now
    if envelope_response
      job_offer_details.envelope_guid = envelope_response
      flash[:notice] = 'Paperwork sent successfully.'
    else
      flash[:error] = 'Could not send paperwork automatically. Please send now manually.'
    end
    job_offer_details.save
    @candidate.paperwork_sent!
    redirect_to @candidate
  end

  def new_sms_message
    @messages = CandidateSMSMessage.all
  end

  def create_sms_message
    message = sms_message_params[:contact_message]
    gateway = Gateway.new '+18133441170'
    gateway.send_text_to_candidate @candidate, message, @current_person
    flash[:notice] = 'Message successfully sent.'
    redirect_to candidate_path(@candidate)
  end

  def record_assessment_score
    begin
      @score = Float params[:assessment_score]
    rescue
      flash[:error] = 'Score must be a number'
      redirect_to candidate_path(@candidate) and return
    end
    if @score > 100
      flash[:error] = 'Score cannot be greater than 100. Please try again.'
      redirect_to candidate_path(@candidate) and return
    end
    if @score < 31
      failed_assessment
    else
      passed_assessment
    end
  end

  def resend_assessment
    unless @candidate.location_area
      flash[:error] = 'You cannot resend the assessment because there is no location selected for the candidate.'
      redirect_to @candidate and return
    end
    CandidatePrescreenAssessmentMailer.assessment_mailer(@candidate, @candidate.location_area.area).deliver_later
    @current_person.log? 'sent_assessment',
                         @candidate
    flash[:notice] = 'Personality assessment email resent.'
    redirect_to @candidate
  end

  def edit_availability
    if @candidate.candidate_availability
      @candidate_availability = @candidate.candidate_availability
    else
      @candidate_availability = CandidateAvailability.new
    end
  end

  def update_availability
    if @candidate.candidate_availability
      @candidate_availability = @candidate.candidate_availability
      @candidate_availability.update_attributes availability_params
    else
      @candidate_availability = CandidateAvailability.new
      @candidate_availability.attributes = availability_params
      @candidate_availability.candidate = @candidate
    end
    if @candidate_availability.save
      flash[:notice] = 'Candidate Availability Updated'
      redirect_to candidate_path @candidate
      @current_person.log? 'update_availability',
                           @candidate
    end
  end

  private

  def availability_params
    params.require(:candidate_availability).permit(
        :monday_first,
        :monday_second,
        :monday_third,
        :tuesday_first,
        :tuesday_second,
        :tuesday_third,
        :wednesday_first,
        :wednesday_second,
        :wednesday_third,
        :thursday_first,
        :thursday_second,
        :thursday_third,
        :friday_first,
        :friday_second,
        :friday_third,
        :saturday_first,
        :saturday_second,
        :saturday_third,
        :sunday_first,
        :sunday_second,
        :sunday_third,
        :comment
    )
  end

  def search_bar
    @search = Candidate.search(params[:q])
  end

  def reset_candidate_status
    @candidate.entered!
    if @candidate.job_offer_details.any?
      @candidate.paperwork_sent!
    elsif @candidate.interview_answers.any?
      @candidate.interviewed!
    elsif @candidate.interview_schedules.any?
      @candidate.interview_scheduled!
    elsif @candidate.location_area.present?
      @candidate.location_selected!
    elsif @candidate.prescreen_answers.any?
      @candidate.prescreened!
    else
      @candidate.entered!
    end
  end

  def create_and_prescreen
    @current_person.log? 'create',
                         @candidate
    flash[:notice] = 'Candidate saved!'
    redirect_to new_candidate_prescreen_answer_path @candidate
  end

  def create_without_prescreen
    call_initiated = Time.at(params[:call_initiated].to_i)
    @current_person.log? 'create',
                         @candidate
    create_voicemail_contact(call_initiated)
    flash[:notice] = 'Candidate saved!'
    redirect_to candidates_path
  end

  def get_suffixes_and_sources
    @sources = CandidateSource.where active: true
    @suffixes = ['', 'Jr.', 'Sr.', 'II', 'III', 'IV']
  end

  def create_voicemail_contact(time)
    call_initiated = time
    CandidateContact.create candidate: @candidate,
                            person: @current_person,
                            contact_method: :phone,
                            inbound: false,
                            notes: 'Left Voicemail',
                            created_at: call_initiated
  end

  def get_candidate
    @candidate = Candidate.find params[:id]
  end

  def candidate_params
    params.require(:candidate).permit(:first_name,
                                      :last_name,
                                      :suffix,
                                      :mobile_phone,
                                      :email,
                                      :zip,
                                      :project_id,
                                      :candidate_source_id,
                                      :start_prescreen
    )
  end

  def sms_message_params
    params.permit :contact_message
  end

  def do_authorization
    authorize Candidate.new
  end

  def get_all_location_areas
    all_locations = Location.
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
    return LocationArea.none if all_locations.count(:all) < 1
    all_locations = Location.where("locations.id IN (#{all_locations.map(&:id).join(',')})")
    locations = all_locations.near(@candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = all_locations.near(@candidate, 500).first(5)
    end
    return LocationArea.none if locations.empty?
    location_areas = locations.map { |l| l.location_areas }.flatten
    LocationAreaPolicy::Scope.new(@current_person, LocationArea.where("location_areas.id IN (#{location_areas.map(&:id).join(',')}) AND active = true")).resolve
  end

  def get_staffable_projects
    Project.
        joins(:areas).
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
  end

  def get_project_location_areas(project)
    project_locations = Project.locations(project)
    locations = project_locations.near(@candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = project_locations.near(@candidate, 500).first(5)
    end
    LocationArea.
        where(location: locations).
        joins(:area).
        where("areas.project_id = ?", project.id)
  end

  def get_location_areas(location)
    location.
        location_areas.
        joins(:area).
        where('areas.project_id = ?', @candidate.project_id)
  end

  def order_by_distance(location_areas)
    return [] if location_areas.empty? or not @candidate
    location_areas.sort do |x, y|
      x.location.geographic_distance(@candidate) <=>
          y.location.geographic_distance(@candidate)
    end
  end

  def set_datetime_range
    @datetime_start = (DateTime.now.in_time_zone +
        Time.zone.utc_offset +
        (DateTime.now.in_time_zone.dst? ? 3600 : 0)).
        beginning_of_day
    @datetime_end = (DateTime.now.in_time_zone +
        Time.zone.utc_offset +
        (DateTime.now.in_time_zone.dst? ? 3600 : 0)).
        end_of_day
  end

  def set_entered
    @entered_range = Candidate.where(
        "created_at >= ? AND created_at <= ?",
        @datetime_start,
        @datetime_end
    )
    @entered_total = Candidate.where(status: Candidate.statuses[:entered].to_i, active: true)
  end

  def set_prescreened
    @prescreened_range = Candidate.
        joins(:prescreen_answers).
        where("prescreen_answers.created_at >= ? AND prescreen_answers.created_at <= ?",
              @datetime_start,
              @datetime_end)
    @prescreened_total = Candidate.where(status: Candidate.statuses[:prescreened].to_i, active: true)
  end

  def set_interview_scheduled
    @interview_scheduled_range = Candidate.
        joins(:interview_schedules).
        where("interview_schedules.created_at >= ? AND interview_schedules.created_at <= ?",
              @datetime_start,
              @datetime_end)
    @interview_scheduled_total = Candidate.where(status: Candidate.statuses[:interview_scheduled].to_i, active: true)
  end

  def set_accepted
    @accepted_range = Candidate.
        joins(:interview_answers).
        where("interview_answers.created_at >= ? AND interview_answers.created_at <= ? AND candidates.active = true",
              @datetime_start,
              @datetime_end)
    @accepted_total = Candidate.where(status: Candidate.statuses[:accepted].to_i, active: true)
  end

  def set_paperwork_sent
    @paperwork_sent_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.sent >= ? AND job_offer_details.sent <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_sent_total = Candidate.where(status: Candidate.statuses[:paperwork_sent].to_i, active: true)
  end

  def set_paperwork_completed_by_candidate
    @paperwork_completed_by_candidate_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.completed_by_candidate >= ? AND job_offer_details.completed_by_candidate <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_completed_by_candidate_total = Candidate.where(status: Candidate.statuses[:paperwork_completed_by_candidate].to_i, active: true)
  end

  def set_paperwork_completed_by_advocate
    @paperwork_completed_by_advocate_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.completed_by_advocate >= ? AND job_offer_details.completed_by_advocate <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_completed_by_advocate_total = Candidate.where(status: Candidate.statuses[:paperwork_completed_by_advocate].to_i, active: true)
  end

  def set_paperwork_completed_by_hr
    @paperwork_completed_by_hr_range = Candidate.
        joins(:job_offer_details).
        where("job_offer_details.completed >= ? AND job_offer_details.completed <= ?",
              @datetime_start,
              @datetime_end)
    @paperwork_completed_by_hr_total = Candidate.where(status: Candidate.statuses[:paperwork_completed_by_hr].to_i, active: true)
  end

  def set_onboarded
    @onboarded_range = Candidate.
        joins(:person).
        where(
            "people.created_at >= ? AND people.created_at <= ?",
            @datetime_start,
            @datetime_end
        )
    @onboarded_total = Candidate.where(status: Candidate.statuses[:onboarded].to_i, active: true)
  end

  def set_rejected
    @rejected_range = Candidate.where(
        "active = false AND updated_at >= ? AND updated_at <= ?",
        @datetime_start,
        @datetime_end
    )
    @rejected_total = Candidate.where(status: Candidate.statuses[:rejected].to_i)
  end

  def setup_confirm_form_values
    @training_unavailability_reasons = TrainingUnavailabilityReason.all
    @shirt_gender = params[:shirt_gender]
    @shirt_size = params[:shirt_size]
    @shirt_size = params[:shirt_size]
    @able_to_attend = if params[:able_to_attend] and not params[:able_to_attend].empty?
                        if params[:able_to_attend] == 'false'
                          false
                        else
                          true
                        end
                      else
                        nil
                      end
    @training_unavailability_reason_id = params[:training_unavailability_reason_id]
    @comments = params[:comments]
    @location_area = @candidate.location_area
    @schedule = []
  end

  def set_unable_to_attend_params
    @training_availability.training_unavailability_reason_id = @training_unavailability_reason_id
    @training_availability.comments = @comments
  end

  def geocode_if_necessary
    return if @candidate.state
    @candidate.geocode
    @candidate.reverse_geocode
    @candidate.save
  end

  def passed_assessment
    @current_person.log? 'passed_assessment',
                         @candidate
    @candidate.update personality_assessment_completed: true,
                      personality_assessment_score: @score,
                      personality_assessment_status: :qualified
    if @candidate.confirmed?
      redirect_to send_paperwork_candidate_path(@candidate)
    else
      flash[:notice] = 'Marked candidate as having qualified for employment per the personality assessment score. ' +
          'Paperwork will be sent after details are confirmed.'
      redirect_to candidate_path(@candidate)
    end
  end

  def failed_assessment
    denial_reason = CandidateDenialReason.find_by name: "Personality assessment score does not qualify for employment"
    @current_person.log? 'failed_assessment',
                         @candidate
    @current_person.log? 'dismiss',
                         @candidate
    if denial_reason
      @candidate.update active: false,
                        status: :rejected,
                        candidate_denial_reason: denial_reason,
                        personality_assessment_completed: true,
                        personality_assessment_score: @score,
                        personality_assessment_status: :disqualified
    else
      @candidate.update active: false,
                        status: :rejected,
                        personality_assessment_completed: true,
                        personality_assessment_score: @score,
                        personality_assessment_status: :disqualified
    end
    flash[:notice] = 'Marked candidate as having been disqualified for employment per the personality assessment score.'
    redirect_to candidate_path(@candidate)
  end
end
