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
    @prescreen_answer = PrescreenAnswer.new prescreen_answer_params
    @call_initiated = Time.at(params[:call_initiated].to_i)
    check_and_handle_blank_call_direction
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

  def setup_params
    @candidate = Candidate.find params[:candidate_id]
    @candidate_availability = CandidateAvailability.new
  end

  def save_prescreen
    if @prescreen_answer.save
      set_prescreened(@call_initiated)
      check_and_handle_location
    else
      flash[:error] = 'Candidate did not pass prescreening'
      @candidate.rejected!
      @candidate.update active: false
      create_prescreen_contact(@call_initiated, false)
      redirect_to new_candidate_path
    end
  end

  def check_and_handle_blank_call_direction
    @inbound = params[:inbound]
    if @inbound.blank?
      flash[:error] = 'You must select whether the call is inbound or outbound.'
      render :new and return
    end
  end

  def check_and_handle_location
    if @candidate.location_selected?
      @location_area = @candidate.location_area
      @location_area.update potential_candidate_count: @location_area.potential_candidate_count + 1
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
                                             :ok_to_screen
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
