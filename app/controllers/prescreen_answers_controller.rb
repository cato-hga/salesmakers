class PrescreenAnswersController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization

  def new
    @prescreen_answer = PrescreenAnswer.new
    @candidate = Candidate.find params[:candidate_id]
    @call_initiated = DateTime.now.to_i
  end

  def create
    @prescreen_answer = PrescreenAnswer.new prescreen_answer_params
    @candidate = Candidate.find params[:candidate_id]
    @inbound = params[:inbound]
    if @inbound.blank?
      flash[:error] = 'You must select whether the call is inbound or outbound.'
      render :new and return
    end
    @prescreen_answer.candidate = @candidate
    if @prescreen_answer.save
      set_prescreened
      redirect_to select_location_candidate_path(@candidate, 'false')
    else
      flash[:error] = 'Candidate did not pass prescreening'
      create_rejection_contact
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

  def set_prescreened
    @candidate.prescreened!
    flash[:notice] = 'Answers saved!'
    @current_person.log? 'prescreen_answer_create',
                         @candidate
    create_acceptance_contact
  end

  def create_acceptance_contact
    call_initiated = Time.at(params[:call_initiated].to_i)
    CandidateContact.create candidate: @candidate,
                            person: @current_person,
                            contact_method: :phone,
                            inbound: @inbound,
                            notes: 'Candidate prescreened successfully.',
                            created_at: call_initiated
  end

  def create_rejection_contact
    call_initiated = Time.at(params[:call_initiated].to_i)
    CandidateContact.create candidate: @candidate,
                            person: @current_person,
                            contact_method: :phone,
                            inbound: @inbound,
                            notes: 'Candidate eliminated during prescreening.',
                            created_at: call_initiated
  end
end
