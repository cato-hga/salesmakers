class InterviewAnswersController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :set_candidate

  def new
    @interview_answer = InterviewAnswer.new
    @denial_reasons = CandidateDenialReason.where active: true
  end

  def create
    @denial_reasons = CandidateDenialReason.where active: true
    @interview_answer = InterviewAnswer.new interview_answer_params
    @interview_answer.candidate = @candidate
    @extend_offer = params.permit(:extend_offer)[:extend_offer] == 'false' ? false : true
    if @interview_answer.save and @extend_offer
      extend_job_offer
    elsif @interview_answer.save
      do_not_extend_offer
    else
      unless @denial_reason
        @interview_answer.errors.add(:denial_reason, "must be selected")
      end
      flash[:error] = "The candidate's interview answers cannot be saved:"
      render :new
    end
  end

  private

  def extend_job_offer
    flash[:notice] = 'Interview answers saved.'
    @candidate.accepted!
    @current_person.log? 'create',
                         @candidate
    @current_person.log? 'extended_job_offer',
                         @candidate
    redirect_to confirm_location_candidate_path(@candidate)
  end

  def do_not_extend_offer
    flash[:notice] = 'Interview answers saved and candidate deactivated'
    @candidate.rejected!
    @denial_reason = params[:interview_answer][:candidate][:candidate_denial_reason_id]
    @candidate.update active: false, candidate_denial_reason_id: @denial_reason
    @current_person.log? 'create',
                         @candidate
    denial_reason = CandidateDenialReason.find_by id: @denial_reason
    @current_person.log? 'job_offer_not_extended',
                         @candidate,
                         denial_reason
    redirect_to new_candidate_path
  end

  def interview_answer_params
    params.require(:interview_answer).permit :work_history,
                                             :why_in_market,
                                             :ideal_position,
                                             :what_are_you_good_at,
                                             :what_are_you_not_good_at,
                                             :willingness_characteristic,
                                             :personality_characteristic,
                                             :self_motivated_characteristic,
                                             :compensation_last_job_one,
                                             :compensation_last_job_two,
                                             :compensation_last_job_three,
                                             :compensation_seeking,
                                             :hours_looking_to_work,
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
