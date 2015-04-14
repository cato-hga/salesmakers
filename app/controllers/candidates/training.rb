module Candidates::Training
  def cant_make_training_location
    reason = TrainingUnavailabilityReason.find_by name: "Can't Make Training Location"
    @training_availability = TrainingAvailability.new
    @training_availability.able_to_attend = false
    @training_availability.candidate = @candidate
    @training_availability.training_unavailability_reason = reason
    if @training_availability.save
      flash[:notice] = "Candidate marked as not being able to make their training location"
      redirect_to candidate_path(@candidate)
    else
      flash[:error] = "Unavailability could not be saved"
      redirect_to candidate_path(@candidate)
    end
  end

  def set_sprint_radio_shack_training_session
    @sprint_radio_shack_training_session_id = sprint_radio_shack_training_session_params[:id]
    if @candidate.update sprint_radio_shack_training_session_id: @sprint_radio_shack_training_session_id
      flash[:notice] = 'Saved training session'
    else
      flash[:error] = 'Could not save training session'
    end
    redirect_to candidate_path(@candidate)
  end

  private

  def sprint_radio_shack_training_session_params
    params.require(:sprint_radio_shack_training_session).permit :id
  end

  def setup_sprint_params
    if @candidate.location_area and @candidate.location_area.location and @candidate.location_area.location.sprint_radio_shack_training_location
      @training_location = @candidate.location_area.location.sprint_radio_shack_training_location
    else
      @training_location = nil
    end
    @sprint_radio_shack_training_sessions = SprintRadioShackTrainingSession.all
    @sprint_radio_shack_training_session = @candidate.sprint_radio_shack_training_session ?
        @candidate.sprint_radio_shack_training_session :
        SprintRadioShackTrainingSession.new
  end
end