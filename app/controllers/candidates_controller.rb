require 'apis/gateway'

class CandidatesController < ApplicationController
  include CandidateDashboard
  include AvailabilityParams

  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar, except: [:support_search]
  before_action :get_candidate, except: [:index, :support_search, :dashboard, :new, :create]
  before_action :get_suffixes_and_sources, only: [:new, :create, :edit, :update]

  layout 'candidates', except: [:support_search]
  layout 'application', only: [:support_search]

  def index
    @candidates = @search.result.page(params[:page])
  end

  def support_search
    region = AreaType.where name: 'Sprint Postpaid Region'
    @regions = Area.where area_type: region
    statuses = Candidate.statuses
    @search = Candidate.where("status >= 10").search(params[:q])
    @statuses = []
    for status in statuses do
      @statuses << status if status[1] >= 10
    end
    @candidates = @search.result.page(params[:page])
  end

  def dashboard
    set_datetime_range
    set_dashboard_variables
    set_passed_sex_offender_check
    set_passed_public_background_check
    set_passed_private_background_check
    set_passed_drug_screening
    set_partially_screened
    set_fully_screened
  end

  def show
    @candidate = Candidate.find params[:id]
    @candidate_contacts = @candidate.candidate_contacts
    @log_entries = @candidate.related_log_entries.page(params[:log_entries_page]).per(10)
    setup_sprint_params
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
    outsourced = CandidateSource.find_by name: 'Outsourced'
    @select_location = params[:select_location] == 'true' ? true : false
    check_and_handle_unmatched_candidates
    if @candidate_source == outsourced
      handle_outsourced
    elsif @candidate.save and @select_location
      create_and_select_location
    elsif @candidate.save
      create_without_selecting_location
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
    all_location_areas = LocationArea.get_all_location_areas(@candidate, @current_person)
    @location_area_search = all_location_areas.search(params[:q])
    @location_areas = order_by_distance(@location_area_search.result)
    @candidate.assign_potential_territory(@location_areas)
    @back_to_confirm = params[:back_to_confirm] == 'true' ? true : false
  end

  def set_location_area
    @location_area = LocationArea.find params[:location_area_id]
    @back_to_confirm = params[:back_to_confirm] == 'true' ? true : false
    @previous_location_area = @candidate.location_area
    if @candidate.update location_area: @location_area
      handle_location_area
    else
      flash[:error] = @candidate.errors.full_messages.join(', ')
      redirect_to select_location_candidate_path(@candidate, @back_to_confirm.to_s)
    end
  end

  def send_paperwork
    geocode_if_necessary
    if Rails.env.staging? or Rails.env.development? or Rails.env.test?
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
    if @candidate.mobile_phone.length != 10
      flash[:error] = "Sorry, but the candidate's phone number is not " +
          "10 digits long. Please correct the phone number to send text messages"
      redirect_to :back and return
    end
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

  def cant_make_training_location
    reason = TrainingUnavailabilityReason.find_by name: "Can't Make Training Location"
    @training_availability = TrainingAvailability.new
    @training_availability.able_to_attend = false
    @training_availability.candidate = @candidate
    @training_availability.training_unavailability_reason = reason
    if @training_availability.save
      flash[:notice] = "Candidate marked as not being able to make their training location"
      redirect_to candidate_path(@candidate)
    else
      flash[:error] = "Unavailability could not be saved"
      redirect_to candidate_path(@candidate)
    end
  end

  def set_sprint_radio_shack_training_session
    @sprint_radio_shack_training_session_id = sprint_radio_shack_training_session_params[:id]
    if @candidate.update sprint_radio_shack_training_session_id: @sprint_radio_shack_training_session_id
      flash[:notice] = 'Saved training session'
    else
      flash[:error] = 'Could not save training session'
    end
    redirect_to candidate_path(@candidate)
  end

  private

  def check_and_handle_unmatched_candidates
    unmatched_candidate = UnmatchedCandidate.find_by email: @candidate.email
    return unless unmatched_candidate
    person = Person.find_by email: 'retailingw@retaildoneright.com'
    if unmatched_candidate.score < 31
      SprintPersonalityAssessmentProcessing.failed_assessment @candidate, unmatched_candidate.score, person
    else
      SprintPersonalityAssessmentProcessing.passed_assessment @candidate, unmatched_candidate.score, person
    end
  end

  def setup_sprint_params
    if @candidate.location_area and @candidate.location_area.location and @candidate.location_area.location.sprint_radio_shack_training_location
      @training_location = @candidate.location_area.location.sprint_radio_shack_training_location
    else
      @training_location = nil
    end
    @sprint_radio_shack_training_sessions = SprintRadioShackTrainingSession.all
    @sprint_radio_shack_training_session = @candidate.sprint_radio_shack_training_session ?
        @candidate.sprint_radio_shack_training_session :
        SprintRadioShackTrainingSession.new
  end

  def handle_location_area
    if @previous_location_area
      candidate_has_previous_location_area
    end
    if @location_area.outsourced?
      candidate_location_outsourced and return
    end
    if @back_to_confirm
      back_to_confirmation and return
    else
      candidate_location_completion
    end
  end

  def handle_outsourced
    if @candidate.save
      @current_person.log? 'create',
                           @candidate
      flash[:notice] = 'Outsourced candidate saved!'
      redirect_to select_location_candidate_path(@candidate, 'false')
    else
      render :new
    end
  end

  def candidate_has_previous_location_area
    @previous_location_area.update potential_candidate_count: @previous_location_area.potential_candidate_count - 1
    if Candidate.statuses[@candidate.status] >= Candidate.statuses['accepted']
      @previous_location_area.update offer_extended_count: @previous_location_area.offer_extended_count - 1
    end
  end

  def candidate_location_outsourced
    @candidate.accepted!
    @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
    @location_area.update offer_extended_count: @location_area.offer_extended_count + 1
    flash[:notice] = 'Location chosen successfully.'
    redirect_to new_candidate_training_availability_path(@candidate)
  end

  def candidate_is_prescreened
    @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
    flash[:notice] = 'Location chosen successfully. You were redirected to the candidate page because the candidate was already prescreened'
    redirect_to candidate_path(@candidate)
  end

  def back_to_confirm
    flash[:notice] = 'Location chosen successfully.'
    redirect_to (new_candidate_training_availability_path(@candidate))
  end

  def candidate_location_completion
    CandidatePrescreenAssessmentMailer.assessment_mailer(@candidate, @location_area.area).deliver_later
    @current_person.log? 'sent_assessment',
                         @candidate
    if @candidate.prescreened?
      candidate_is_prescreened and return
    else
      @candidate.location_selected! if @candidate.status == 'entered'
      flash[:notice] = 'Location chosen successfully.'
      redirect_to new_candidate_prescreen_answer_path(@candidate)
    end
  end

  def sprint_radio_shack_training_session_params
    params.require(:sprint_radio_shack_training_session).permit :id
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

  def create_and_select_location
    @current_person.log? 'create',
                         @candidate
    flash[:notice] = 'Candidate saved!'
    redirect_to select_location_candidate_path(@candidate, 'false')
  end

  def create_without_selecting_location
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

  def geocode_if_necessary
    return if @candidate.state
    @candidate.geocode
    @candidate.reverse_geocode
    @candidate.save
  end

  def passed_assessment
    SprintPersonalityAssessmentProcessing.passed_assessment(@candidate, @score, @current_person)
    if @candidate.confirmed?
      redirect_to send_paperwork_candidate_path(@candidate)
    else
      flash[:notice] = 'Marked candidate as having qualified for employment per the personality assessment score. ' +
          'Paperwork will be sent after details are confirmed.'
      redirect_to candidate_path(@candidate)
    end
  end

  def failed_assessment
    SprintPersonalityAssessmentProcessing.failed_assessment(@candidate, @score, @current_person)
    flash[:notice] = 'Marked candidate as having been disqualified for employment per the personality assessment score.'
    redirect_to candidate_path(@candidate)
  end

end
