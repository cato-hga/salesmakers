class PrescreenAnswersController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization

  def new
    @prescreen_answer = PrescreenAnswer.new
    @candidate = Candidate.find params[:candidate_id]
  end

  def create
    @prescreen_answer = PrescreenAnswer.new prescreen_answer_params
    @candidate = Candidate.find params[:candidate_id]
    @prescreen_answer.candidate = @candidate
    if @prescreen_answer.save
      @candidate.prescreened!
      flash[:notice] = 'Answers saved!'
      @current_person.log? 'create',
                           @candidate
      redirect_to select_location_candidate_path(@candidate)
    else
      flash[:error] = 'Candidate did not pass prescreening'
      redirect_to new_candidate_path
    end
  end

  private

  def prescreen_answer_params
    params.require(:prescreen_answer).permit(:worked_for_salesmakers,
                                             :of_age_to_work,
                                             :eligible_smart_phone,
                                             :can_work_weekends,
                                             :reliable_transportation,
                                             :access_to_computer,
                                             :part_time_employment,
                                             :ok_to_screen
    )
  end

  def do_authorization
    authorize Candidate.new
  end
end
