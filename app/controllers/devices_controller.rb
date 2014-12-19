class DevicesController < ApplicationController
  before_action :set_models_and_providers, only: [:new, :create]
  before_action :set_device_and_device_state, only: [:remove_state, :add_state]

  def index
    @search = Device.search(params[:q])
    @devices = @search.result.order('serial').page(params[:page])
  end

  def show
    @device = Device.find params[:id]
    @unlocked_device_states = DeviceState.where locked: false
    @log_entries = LogEntry.where("(trackable_type = 'Device' AND trackable_id = #{@device.id}) OR (trackable_type = 'DeviceDeployment' AND referenceable_id = #{@device.id})").order('created_at DESC')
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new
    @contract_end_date = receive_params[:contract_end_date]
    @device_model = DeviceModel.find receive_params[:device_model_id] unless receive_params[:device_model_id].blank?
    @service_provider = TechnologyServiceProvider.find receive_params[:technology_service_provider_id] unless receive_params[:technology_service_provider_id].blank?
    @serials = receive_params[:serial]
    @line_identifiers = receive_params[:line_identifier]
    serial_count = 0
    @bad_receivers = Array.new
    clean_blank_rows
    unless has_rows?
      flash[:error] = 'You did not enter any device information'
      render :new and return
    end
    for serial in @serials do
      line_identifier = @line_identifiers[serial_count]
      next if serial.blank? and line_identifier.blank?
      receiver = AssetReceiver.new contract_end_date: @contract_end_date,
                                   device_model: @device_model,
                                   service_provider: @service_provider,
                                   serial: serial,
                                   line_identifier: line_identifier,
                                   creator: @current_person
      unless receiver.valid?
        @bad_receivers << receiver
      else
        receiver.receive
      end
      serial_count+= 1
    end
    if @bad_receivers.count > 0
      render :new
    else
      flash[:notice] = 'All assets received successfully'
      redirect_to devices_path
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

  def remove_state
    if @device and @device_state
      deleted = @device.device_states.delete @device_state
      if deleted
        flash[:notice] = 'State removed from device'
        redirect_to device_path(@device)
      end
    else
      flash[:error] = 'Could not find that device or device state'
      redirect_to device_path(@device)
    end
  end

  def add_state
    if @device and @device_state
      @device.device_states << @device_state
      @device.reload
      if @device.device_states.include?(@device_state)
        flash[:notice] = 'State added to device'
        redirect_to device_path(@device)
      else
        flash[:error] = 'State could not be added to device'
        redirect_to device_path(@device)
      end
    else
      flash[:error] = 'Could not find that device or device state'
      redirect_to device_path(@device)
    end
  end

  private

  def receive_params
    params.permit :contract_end_date, :device_model_id, :technology_service_provider_id, serial: [], line_identifier: []
  end

  def state_params
    params.permit :id, :device_state_id
  end

  def set_models_and_providers
    @device_models = DeviceModel.all
    @service_providers = TechnologyServiceProvider.all
  end

  def set_device_and_device_state
    @device = Device.find state_params[:id]
    if state_params[:device_state_id].blank?
      flash[:error] = 'You did not select a state to add'
      redirect_to device_path(@device) and return
    end
    @device_state = DeviceState.find state_params[:device_state_id]
    if @device_state.locked?
      flash[:error] = 'You cannot add or remove built-in device states'
      redirect_to device_path(@device) and return
    end
  end

  def clean_blank_rows
    non_blank_serials = Array.new
    non_blank_line_ids = Array.new
    serial_count = -1
    for serial in @serials do
      serial_count += 1
      next if serial.blank? and @line_identifiers[serial_count].blank?
      non_blank_serials << serial
      non_blank_line_ids << @line_identifiers[serial_count]
    end
    @serials = non_blank_serials
    @line_identifiers = non_blank_line_ids
  end

  def has_rows?
    @serials.count > 0 or @line_identifiers.count > 0
  end
end
