class CandidatesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization

  def new
    @candidate = Candidate.new
    @projects = Project.all
  end

  def create
    @candidate = Candidate.new candidate_params
    if @candidate.save
      @current_person.log? 'candidate_create',
                           @candidate
      flash[:notice] = 'Candidate saved!'
      redirect_to new_candidate_prescreen_answer_path @candidate
    else
      render :new
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:first_name,
                                      :last_name,
                                      :suffix,
                                      :mobile_phone,
                                      :email,
                                      :zip,
                                      :project_id
    )
  end

  def do_authorization
    authorize Candidate.new
  end
end
