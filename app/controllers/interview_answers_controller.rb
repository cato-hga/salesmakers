class InterviewAnswersController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :set_candidate

  def new
    @interview_answer = InterviewAnswer.new
  end

  def create
    @interview_answer = InterviewAnswer.new interview_answer_params
    @interview_answer.candidate = @candidate
    if @interview_answer.save and params.permit(:extend_offer)[:extend_offer] != 'false'
      flash[:notice] = 'Interview answers saved and job offer extended'
      @candidate.accepted!
      @current_person.log? 'interview_answer_create',
                           @candidate
      @current_person.log? 'extended_job_offer',
                           @candidate
      redirect_to @candidate
    elsif @interview_answer.save and params.permit(:extend_offer)[:extend_offer] == 'false'
      flash[:notice] = 'Interview answers saved and candidate deactivated'
      @candidate.rejected!
      @candidate.update active: false
      @current_person.log? 'interview_answer_create',
                           @candidate
      @current_person.log? 'job_offer_not_extended',
                           @candidate
      redirect_to new_candidate_path
    else
      flash[:error] = "The candidate's interview answers cannot be saved"
      render :new
    end
  end

  private

  def interview_answer_params
    params.require(:interview_answer).permit :work_history,
                                             :why_in_market,
                                             :ideal_position,
                                             :what_are_you_good_at,
                                             :what_are_you_not_good_at,
                                             :compensation_last_job_one,
                                             :compensation_last_job_two,
                                             :compensation_last_job_three,
                                             :compensation_seeking,
                                             :hours_looking_to_work,
                                             :extend_offer
  end

  def do_authorization
    authorize Candidate.new
  end

  def set_candidate
    @candidate = Candidate.find params[:candidate_id]
  end
end
