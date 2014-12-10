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
    @device_models = DeviceModel.all
    @service_providers = TechnologyServiceProvider.all
    @device = Device.new
  end

  def create
    @contract_end_date = Date.strptime receive_params[:contract_end_date], '%m/%d/%Y'
    @device_model = DeviceModel.find receive_params[:device_model_id]
    @service_provider = TechnologyServiceProvider.find receive_params[:technology_service_provider_id]
    @serial = receive_params[:serial]
    @line_identifier = receive_params[:line_identifier]
    receiver = AssetReceiver.new contract_end_date: @contract_end_date,
                                 device_model: @device_model,
                                 service_provider: @service_provider,
                                 serial: @serial,
                                 line_identifier: @line_identifier,
                                 creator: @current_person
    begin
      receiver.receive
      flash[:notice] = 'Device(s) received successfully'
    end
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

  private

  def receive_params
    params.permit :contract_end_date, :device_model_id, :technology_service_provider_id, :serial, :line_identifier
  end
end
