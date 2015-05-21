class LocationsController < ApplicationController
  before_action :set_necessary_variables
  after_action :verify_authorized

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
                                          area_id: @area_id
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
end