class TrainingAvailabilitiesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar
  before_action :get_candidate

  def new
    @training_availability = TrainingAvailability.new
  end

  def create
    @training_availability = TrainingAvailability.new
    if params[:training_availability][:shirt_gender].blank? or params[:training_availability][:shirt_size].blank?
      flash[:error] = 'You must select a shirt gender and size to proceed.'
      render :new and return
    end
    @training_availability.able_to_attend = params[:training_availability][:able_to_attend]
    @training_availability.candidate = @candidate
    unless params[:training_availability][:able_to_attend] == 'true'
      @training_availability.training_unavailability_reason_id = params[:training_availability][:training_unavailability_reason_id]
      @training_availability.comments = params[:training_availability][:comments]
    end
    if @training_availability.save
      @candidate.shirt_size = params[:training_availability][:shirt_size]
      @candidate.shirt_gender = params[:training_availability][:shirt_gender]
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

  private

  def do_authorization
    authorize Candidate.new
  end

  def get_candidate
    @candidate = Candidate.find params[:candidate_id]
  end

  def search_bar
    @search = Candidate.search(params[:q])
  end

end