class LocationsController < ApplicationController
  before_action :set_necessary_variables
  after_action :verify_authorized

  def index
    @search = LocationArea.joins(:area).where("areas.project_id = #{@project.id}").search(params[:q])
    @location_areas = @search.result.page(params[:page])
    authorize Location.new
  end

  def show
    @location = Location.find params[:id]
    #candidate_ids = order_by_distance(Candidate.near(@location, 30)).map {|c| c.id}.uniq
    #@candidates = Candidate.unscoped.where(id: candidate_ids).page(params[:candidate_page]).per(10)
    @candidates = Candidate.
        unscoped.
        where("candidates.status < ?", Candidate.statuses[:onboarded]).
        near(@location, 30).
        page(params[:candidate_page]).
        per(10)
    @person_addresses = PersonAddress.near(@location, 30)
    people_ids = @person_addresses.map {|pa| pa.person.id }.uniq
    @people = Person.where(id: people_ids).page(params[:person_page]).per(10)
    authorize @location
  end

  def new
    @location = Location.new
    authorize @location
  end

  def create
    authorize Location.new
    @location = Location.new location_params
    unless @area_id
      flash[:error] = 'Area cannot be blank'
      render :new and return
    end
    if @location.save
      location_area = LocationArea.create location: @location,
                                          area_id: @area_id,
                                          priority: params[:priority] ? params[:priority].to_i : nil,
                                          target_head_count: params[:target_head_count] ? params[:target_head_count].to_i : 0
      @current_person.log? 'create',
                           @location,
                           location_area
      flash[:notice] = 'Location successfully saved.'
      redirect_to new_client_project_location_path(@client, @project)
    else
      render :new
    end
  end

  private

  def set_necessary_variables
    @client = Client.find params[:client_id]
    @project = Project.find params[:project_id]
    @areas = @project.areas
    @area_id = params.andand[:area_id]
    @states = ::UnitedStates
  end

  def location_params
    params.require(:location).permit :channel_id,
                                     :store_number,
                                     :display_name,
                                     :street_1,
                                     :street_2,
                                     :city,
                                     :state,
                                     :zip,
                                     :cost_center,
                                     :mail_stop
  end

  def order_by_distance(candidates)
    return [] if candidates.empty? or not @location
    candidates.sort do |x, y|
      @location.geographic_distance(x) <=>
          @location.geographic_distance(x)
    end
  end
end