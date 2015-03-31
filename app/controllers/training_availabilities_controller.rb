class TrainingAvailabilitiesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar
  before_action :setup_params
  layout 'candidates'

  def new

  end

  def create
    @training_availability = TrainingAvailability.new training_availability_params
    if params[:training_availability][:candidate][:shirt_gender].blank? or params[:training_availability][:candidate][:shirt_size].blank?
      flash[:error] = 'You must select a shirt gender and size to proceed.'
      render :new and return
    end
    @training_availability.able_to_attend = params[:training_availability][:able_to_attend]
    @training_availability.candidate = @candidate
    unless params[:training_availability][:able_to_attend] == 'true'
      @training_availability.training_unavailability_reason_id = params[:training_availability][:training_unavailability_reason_id]
      @training_availability.comments = params[:training_availability][:comments] if params[:training_availability][:comments]
    end
    if @training_availability.save
      @candidate.shirt_size = params[:training_availability][:candidate][:shirt_size]
      @candidate.shirt_gender = params[:training_availability][:candidate][:shirt_gender]
      @candidate.save
      @current_person.log? 'confirmed',
                           @candidate
      @candidate.confirmed!
      if @candidate.active? and @candidate.job_offer_details.any?
        flash[:notice] = 'Confirmation recorded'
        redirect_to candidate_path @candidate
      elsif @candidate.active? and @candidate.passed_personality_assessment?
        redirect_to send_paperwork_candidate_path(@candidate)
      else
        flash[:notice] = 'Confirmation recorded. Paperwork will be sent when personality assessment is passed.'
        redirect_to candidate_path(@candidate)
      end
    else
      render :new
    end
  end

  def edit

  end

  def update
    if params[:training_availability][:candidate][:shirt_gender].blank? or params[:training_availability][:candidate][:shirt_size].blank?
      flash[:error] = 'You must select a shirt gender and size to proceed.'
      render :edit and return
    end
    @training_availability.able_to_attend = params[:training_availability][:able_to_attend]
    @training_availability.candidate = @candidate
    unless params[:training_availability][:able_to_attend] == 'true'
      @training_availability.training_unavailability_reason_id = params[:training_availability][:training_unavailability_reason_id]
      @training_availability.comments = params[:training_availability][:comments] if params[:training_availability][:comments]
    end
    @candidate.shirt_size = params[:training_availability][:candidate][:shirt_size]
    @candidate.shirt_gender = params[:training_availability][:candidate][:shirt_gender]
    if @training_availability.save and @candidate.save
      @current_person.log? 'update',
                           @candidate
      flash[:notice] = 'Candidate updated'
      redirect_to candidate_path @candidate
    else
      flash[:error] = 'Candidate could not be updated'
      render :edit
    end
  end

  private

  def setup_params
    @candidate = Candidate.find params[:candidate_id]
    if @candidate.training_availability
      @training_availability = @candidate.training_availability
      @comments = @candidate.training_availability.comments
    else
      @training_availability = TrainingAvailability.new
      @comments = ''
    end
    @location_area = @candidate.location_area
    @location = @location_area.location
    @training_location = @location.sprint_radio_shack_training_location if @location.sprint_radio_shack_training_location
    @unavailability_reasons = TrainingUnavailabilityReason.all
  end

  def training_availability_params
    params.require(:training_availability).permit(:able_to_attend,
                                                  :training_unavailability_reason_id,
                                                  :comments,
                                                  candidate_attributes: [
                                                      :shirt_size,
                                                      :shirt_gender
                                                  ]

    )
  end
  def do_authorization
    authorize Candidate.new
  end

  def get_candidate
  end

  def search_bar
    @search = Candidate.search(params[:q])
  end

end