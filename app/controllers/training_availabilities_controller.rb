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
    @training_availability.candidate = @candidate
    check_for_blank_shirt_info
    @candidate.shirt_size = params[:training_availability][:candidate][:shirt_size]
    @candidate.shirt_gender = params[:training_availability][:candidate][:shirt_gender]
    if @training_availability.save and @candidate.save
      confirm_and_redirect
    else
      puts @training_availability.errors.full_messages.join(',')
      flash[:error] = 'Candidate could not be saved'
      render :new
    end
  end

  def edit

  end

  def update
    check_for_blank_shirt_info
    @candidate.shirt_size = params[:training_availability][:candidate][:shirt_size]
    @candidate.shirt_gender = params[:training_availability][:candidate][:shirt_gender]
    if @training_availability.update training_availability_params and @candidate.save
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
    if @candidate.training_availability.present?
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

  def confirm_and_redirect
    @current_person.log? 'confirmed',
                         @candidate
    @candidate.confirmed!
    if @candidate.active? and @candidate.job_offer_details.any?
      flash[:notice] = 'Confirmation recorded'
      redirect_to candidate_path @candidate and return
    elsif @candidate.active? and @candidate.passed_personality_assessment?
      redirect_to send_paperwork_candidate_path(@candidate) and return
    else
      flash[:notice] = 'Confirmation recorded. Paperwork will be sent when personality assessment is passed.'
      redirect_to candidate_path(@candidate) and return
    end
  end

  def check_for_blank_shirt_info
    if params[:training_availability][:candidate][:shirt_gender].blank? or params[:training_availability][:candidate][:shirt_size].blank?
      flash[:error] = 'You must select a shirt gender and size to proceed.'
      render :edit and return
    end
  end

end