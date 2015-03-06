class CandidatesController < ApplicationController
  after_action :verify_authorized
  before_action :do_authorization

  def index
    @search = Candidate.search(params[:q])
    @candidates = @search.result.page(params[:page])
  end

  def show
    @candidate = Candidate.find params[:id]
  end

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

  def select_location
    @candidate = Candidate.find params[:id]
    @locations = get_locations(@candidate)
  end

  def set_location
    @candidate = Candidate.find params[:id]
    @location = Location.find params[:location_id]
    location_areas = get_location_areas(@location)
    unless location_areas and @candidate.update(location_area: location_areas.first)
      flash[:error] = "Could not update the candidate's location."
      redirect_to select_location_candidate_path(@candidate) and return
    end
    for location_area in location_areas do
      location_area.update potential_candidate_count: location_area.potential_candidate_count + 1
    end
    @candidate.location_selected!
    flash[:notice] = 'Location chosen successfully.'
    redirect_to new_candidate_interview_schedule_path(@candidate)
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

  def get_locations(candidate)
    project_locations = Project.locations(candidate.project)
    locations = project_locations.near(@candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = project_locations.near(@candidate, 500).first(5)
    end
    locations
  end

  def get_location_areas(location)
    location_areas = location.
        location_areas.
        joins(:area).
        where('areas.project_id = ?', @candidate.project_id)
  end
end
