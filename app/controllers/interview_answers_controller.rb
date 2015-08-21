class InterviewAnswersController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :set_candidate

  def new
    @interview_answer = InterviewAnswer.new
    @denial_reasons = CandidateDenialReason.where active: true
  end

  def create
    handle_previous_interviews
    @denial_reasons = CandidateDenialReason.where active: true
    @interview_answer = InterviewAnswer.new interview_answer_params
    @interview_answer.candidate = @candidate
    @extend_offer = params.permit(:extend_offer)[:extend_offer] == 'false' ? false : true
    if @interview_answer.save and @extend_offer
      extend_job_offer and return
    elsif @interview_answer.save
      do_not_extend_offer and return
    else
      unless @denial_reason
        @interview_answer.errors.add(:denial_reason, "must be selected")
      end
      flash[:error] = "The candidate's interview answers cannot be saved:"
      render :new
    end
  end

  private

  def handle_previous_interviews
    if @candidate.interview_answers.any?
      for interview in @candidate.interview_answers do
        logs = LogEntry.where trackable: interview
        logs.destroy_all
      end
      @candidate.interview_answers.destroy_all
    end
  end

  def extend_job_offer
    @candidate.accepted!
    @current_person.log? 'create',
                         @interview_answer,
                         @candidate
    @current_person.log? 'extended_job_offer',
                         @candidate
    if @candidate.location_area
      location_area = @candidate.location_area
      location_area.update offer_extended_count: location_area.offer_extended_count + 1
    end
    flash[:notice] = 'Interview answers saved.'
    if @candidate.location_area and @candidate.location_area.head_count_full?
      @candidate.update location_area: nil
      flash[:error] = 'The location selected for the candidate was recently filled or is not recruitable. Please select a new, recruitable, location'
      redirect_to @candidate and return
    end
    redirect_to new_candidate_training_availability_path(@candidate)
  end

  def do_not_extend_offer
    flash[:notice] = 'Interview answers saved and candidate deactivated'
    @candidate.rejected!
    @denial_reason = params[:interview_answer][:candidate][:candidate_denial_reason_id]
    @candidate.update active: false, candidate_denial_reason_id: @denial_reason
    @current_person.log? 'create',
                         @interview_answer,
                         @candidate
    denial_reason = CandidateDenialReason.find_by id: @denial_reason
    @current_person.log? 'job_offer_not_extended',
                         @candidate,
                         denial_reason
    redirect_to new_candidate_path
  end

  def interview_answer_params
    params.require(:interview_answer).permit :work_history,
                                             :what_interests_you,
                                             :first_thing_you_sold,
                                             :first_building_of_working_relationship,
                                             :first_rely_on_teaching,
                                             :willingness_characteristic,
                                             :personality_characteristic,
                                             :self_motivated_characteristic,
                                             :compensation_seeking,
                                             :availability_confirm,
                                             :extend_offer,
                                             candidate_attributes: [:candidate_denial_reason_id]
  end

  def do_authorization
    authorize Candidate.new
  end

  def set_candidate
    @candidate = Candidate.find params[:candidate_id]
  end
end
