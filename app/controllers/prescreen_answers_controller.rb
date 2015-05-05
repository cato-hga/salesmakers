class PrescreenAnswersController < ApplicationController
  include AvailabilityParams

  after_action :verify_authorized
  before_action :do_authorization
  before_action :setup_params

  def new
    @prescreen_answer = PrescreenAnswer.new
    @call_initiated = DateTime.now.to_i
    @location_area = @candidate.location_area
  end

  def create
    @candidate = Candidate.find params[:candidate_id]
    if @candidate.prescreen_answers.any?
      @candidate.prescreen_answers.destroy_all
    end
    @prescreen_answer = PrescreenAnswer.new prescreen_answer_params
    radioshack_employment_check; return if performed?
    if @inbound.blank?
      flash[:error] = 'You must select whether the call is inbound or outbound.'
      render :new and return
    end
    @call_initiated = Time.at(params[:call_initiated].to_i)
    @prescreen_answer.candidate = @candidate
    @candidate_availability.attributes = availability_params
    @candidate_availability.candidate = @candidate
    if @candidate_availability.save
      save_prescreen
    else
      flash[:error] = 'At least one availability checkbox must be selected'
      render :new
    end
  end

  private

  def radioshack_employment_check
    @radioshack = prescreen_answer_params[:worked_for_radioshack]
    @start = Chronic.parse params[:prescreen_answer][:former_employment_date_start]
    @end_value = Chronic.parse params[:prescreen_answer][:former_employment_date_end]
    @location = prescreen_answer_params[:store_number_city_state]
    if @radioshack == 'true' and (@start.blank? or @end_value.blank? or @location.blank?)
      if @start.blank?
        @prescreen_answer.errors.add :former_employment_start_date, 'is invalid or blank. Please double check - a start date must be entered'
      end
      if @end_value.blank?
        @prescreen_answer.errors.add :former_employment_end_date, 'is invalid or blank. Please double check - an end date must be entered'
      end
      if @location.blank?
        @prescreen_answer.errors.add :store_number_city_state, 'must be entered'
      end
      render :new and return
    end
  end

  def setup_params
    @candidate = Candidate.find params[:candidate_id]
    @inbound = params[:inbound]
    @candidate_availability = CandidateAvailability.new
  end

  def save_prescreen
    if @prescreen_answer.save
      set_prescreened(@call_initiated)
      check_and_handle_radioshack; return if performed?
      check_and_handle_location
    else
      flash[:error] = 'Candidate did not pass prescreening'
      @candidate.rejected!
      @candidate.update active: false
      create_prescreen_contact(@call_initiated, false)
      redirect_to new_candidate_path
    end
  end

  def check_and_handle_radioshack
    if @radioshack == 'true'
      @prescreen_answer.update former_employment_date_start: @start,
                               former_employment_date_end: @end_value,
                               store_number_city_state: @location
      CandidateFormerRadioShackMailer.vetting_mailer(@candidate, @start.strftime('%m-%d-%Y'), @end_value.strftime('%m-%d-%Y'), @location).deliver_later
      flash[:notice] = 'Answers and Availability saved. The candidate must be vetted by Sprint before proceeding.'
      redirect_to candidate_path(@candidate)
    end
  end

  def check_and_handle_location
    if @candidate.location_selected?
      flash[:notice] = 'Answers and Availability saved'
      redirect_to new_candidate_interview_schedule_path(@candidate)
    else
      flash[:notice] = 'Answers and Availability saved'
      flash[:notice] = 'You were redirected to the candidate profile page because a location has not been selected yet'
      redirect_to candidate_path(@candidate)
    end
  end

  def prescreen_answer_params
    params.require(:prescreen_answer).permit(:worked_for_salesmakers,
                                             :of_age_to_work,
                                             :high_school_diploma,
                                             :can_work_weekends,
                                             :reliable_transportation,
                                             :worked_for_sprint,
                                             :eligible_smart_phone,
                                             :ok_to_screen,
                                             :visible_tattoos,
                                             :store_number_city_state,
                                             :worked_for_radioshack
    )
  end

  def do_authorization
    authorize Candidate.new
  end

  def set_prescreened(time)
    @candidate.prescreened!
    flash[:notice] = 'Answers saved!'
    create_prescreen_contact(time, true)
  end

  def create_prescreen_contact(time, accepted)
    call_initiated = time
    notes = accepted ? 'Candidate prescreened successfully.' : 'Candidate eliminated during prescreening.'
    CandidateContact.create candidate: @candidate,
                            person: @current_person,
                            contact_method: :phone,
                            inbound: @inbound,
                            notes: notes,
                            created_at: (call_initiated ? call_initiated : DateTime.now)
  end

end
