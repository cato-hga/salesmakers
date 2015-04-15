class SprintPreTrainingWelcomeCallsController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar
  before_action :setup_params
  layout 'candidates'

  def new

  end

  def create
    @welcome_call = SprintPreTrainingWelcomeCall.new welcome_call_params
    @welcome_call.candidate = @candidate
    @welcome_call.comment = params[:sprint_pre_training_welcome_call][:training_availability][:comment] if params[:sprint_pre_training_welcome_call][:training_availability][:comment]
    @welcome_call.still_able_to_attend = params[:sprint_pre_training_welcome_call][:still_able_to_attend] if params[:sprint_pre_training_welcome_call][:still_able_to_attend]
    if @welcome_call.save
      saved_welcome_call
    else
      flash[:error] = 'Welcome call could not be updated'
      render :new and return
    end
  end

  private

  def saved_welcome_call
    unless @welcome_call.still_able_to_attend
      not_able_to_attend and return
    end
    if @welcome_call.complete?
      flash[:notice] = 'Welcome Call Completed'
      @welcome_call.completed!
      @current_person.log? 'welcome_call_completed',
                           @candidate
      redirect_to @candidate and return
    end
    @welcome_call.started!
    flash[:notice] = 'Welcome call updated'
    @current_person.log? 'welcome_call_started',
                         @candidate
    redirect_to @candidate and return
  end

  def not_able_to_attend
    if params[:sprint_pre_training_welcome_call][:training_availability][:training_unavailability_reason_id].blank?
      flash[:error] = 'A reason must be selected'
      render :new
    else
      set_not_able_to_attend
    end
  end

  def set_not_able_to_attend
    @training_availability.delete
    reason = TrainingUnavailabilityReason.find_by_id params[:sprint_pre_training_welcome_call][:training_availability][:training_unavailability_reason_id]
    TrainingAvailability.create able_to_attend: false,
                                candidate: @candidate,
                                comments: @welcome_call.comment,
                                training_unavailability_reason: reason
    flash[:notice] = 'Welcome Call Completed'
    @current_person.log? 'welcome_call_completed',
                         @candidate
    @welcome_call.completed!
    redirect_to @candidate
  end

  def do_authorization
    authorize Candidate.new
  end

  def search_bar
    @search = Candidate.search(params[:q])
  end

  def setup_params
    @candidate = Candidate.find params[:candidate_id]
    @training_availability = @candidate.training_availability
    @training_unavailability_reasons = TrainingUnavailabilityReason.all
    if @candidate.sprint_pre_training_welcome_call
      @welcome_call = @candidate.sprint_pre_training_welcome_call
    else
      @welcome_call = SprintPreTrainingWelcomeCall.new
    end
  end

  def welcome_call_params
    params.require(:sprint_pre_training_welcome_call).permit(:group_me_reviewed,
                                                             :group_me_confirmed,
                                                             :cloud_reviewed,
                                                             :cloud_confirmed,
                                                             :epay_reviewed,
                                                             :epay_confirmed,
                                                             :still_able_to_attend,
                                                             training_availability_attributes: [
                                                                 :comment,
                                                                 :training_unavailability_reason_id
                                                             ]
    )
  end
end
