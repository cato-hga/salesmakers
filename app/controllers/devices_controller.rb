class DevicesController < ApplicationController
  def index
    @search = Device.search(params[:q])
    @devices = @search.result.order('serial').page(params[:page])
  end

  def show
    @device = Device.find params[:id]
    @log_entries = LogEntry.where("(trackable_type = 'Device' AND trackable_id = #{@device.id}) OR (trackable_type = 'DeviceDeployment' AND referenceable_id = #{@device.id})").order('created_at DESC')
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def write_off
    @device = Device.find params[:id]
    written_off = DeviceState.find_by name: 'Written Off'
    @device.device_states << written_off
    @device.save
    @current_person.log? 'write_off', @device, nil
    flash[:notice] = 'Device Written Off!'
    redirect_to @device
  end
end
