class CandidateAvailabilitiesController < ApplicationController
  include AvailabilityParams

  after_action :verify_authorized
  before_action :do_authorization
  before_action :search_bar
  before_action :get_candidate

  def new
    @candidate_availability = CandidateAvailability.new
  end

  def create
    @candidate_availability = CandidateAvailability.new availability_params
    @candidate_availability.candidate = @candidate
    if @candidate_availability.save
      flash[:notice] = 'Candidate Availability Updated'
      redirect_to candidate_path @candidate
      @current_person.log? 'update_availability',
                           @candidate
    end
  end

  def edit
    @candidate_availability = @candidate.candidate_availability
  end

  def update
    @candidate_availability = @candidate.candidate_availability
    @candidate_availability.update_attributes availability_params
    @candidate_availability.candidate = @candidate
    if @candidate_availability.save
      flash[:notice] = 'Candidate Availability Updated'
      redirect_to candidate_path @candidate
      @current_person.log? 'update_availability',
                           @candidate
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
