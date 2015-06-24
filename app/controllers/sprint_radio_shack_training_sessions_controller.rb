class SprintRadioShackTrainingSessionsController < ApplicationController
  after_action :verify_authorized

  def index
    @sprint_radio_shack_training_sessions = SprintRadioShackTrainingSession.all.page(params[:page])
    authorize SprintRadioShackTrainingSession.new
  end

  def new
    @sprint_radio_shack_training_session = SprintRadioShackTrainingSession.new
    authorize @sprint_radio_shack_training_session
  end

  def create
    authorize SprintRadioShackTrainingSession.new
    @sprint_radio_shack_training_session = SprintRadioShackTrainingSession.new sprint_radio_shack_training_session_params
    @sprint_radio_shack_training_session.locked = false unless sprint_radio_shack_training_session_params[:locked]
    @sprint_radio_shack_training_session.start_date = Chronic.parse params.
                                                                        require(:sprint_radio_shack_training_session).
                                                                        permit(:start_date)[:start_date]
    if @sprint_radio_shack_training_session.save
      @current_person.log? 'create',
                           @sprint_radio_shack_training_session
      flash[:notice] = 'Training session saved successfully.'
      redirect_to sprint_radio_shack_training_sessions_path
    else
      render :new
    end
  end

  def edit
    authorize SprintRadioShackTrainingSession.new
    @sprint_radio_shack_training_session = SprintRadioShackTrainingSession.find params[:id]
  end

  def update
    authorize SprintRadioShackTrainingSession.new
    @sprint_radio_shack_training_session = SprintRadioShackTrainingSession.find params[:id]
    @sprint_radio_shack_training_session.attributes = sprint_radio_shack_training_session_params
    @sprint_radio_shack_training_session.locked = false unless sprint_radio_shack_training_session_params[:locked]
    @sprint_radio_shack_training_session.start_date = Chronic.parse params.
                                                                        require(:sprint_radio_shack_training_session).
                                                                        permit(:start_date)[:start_date]
    if @sprint_radio_shack_training_session.save
      @current_person.log? 'update',
                           @sprint_radio_shack_training_session
      flash[:notice] = 'Training session saved successfully.'
      redirect_to sprint_radio_shack_training_sessions_path
    else
      render :edit
    end
  end

  private

  def sprint_radio_shack_training_session_params
    params.require(:sprint_radio_shack_training_session).permit :name, :locked
  end
end