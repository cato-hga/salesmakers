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
    if @interview_answer.save
      puts 'NO'
    else
      puts @interview_answer.errors.full_messages.join(', ')
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
    @candidate = Candidate.find_by params[:id]
  end
end
