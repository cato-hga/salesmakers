class DevicesController < ApplicationController
  before_action :search_bar
  before_action :set_models_and_providers, only: [:new, :create, :edit]
  before_action :set_device_and_device_state, only: [:remove_state, :add_state]
  before_action :do_authorization, except: [:show]
  after_action :verify_authorized

  layout 'devices'

  def index
    authorize Device.new
    @devices = @search.result.order('serial').page(params[:page])
  end

  def csv
    @search = Device.search(params[:q])
    @devices = @search.result.order('serial')
    respond_to do |format|
      format.html { redirect_to devices_path }
      format.csv do
        render csv: @devices,
               filename: "devices_#{date_time_string}",
               except: [
                   :id,
                   :device_model_id,
                   :line_id,
                   :person_id,
                   :identifier,
                   :serial
               ],
               add_methods: [
                   :csv_identifier,
                   :csv_serial,
                   :device_model_name,
                   :csv_line_identifier,
                   :assignee_name
               ]
      end
    end
  end

  def show
    @device = Device.find params[:id]
    authorize @device
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
    @device_identifiers = receive_params[:device_identifier]
    serial_count = 0
    @bad_receivers = Array.new
    clean_blank_rows
    unless has_rows?
      flash[:error] = 'You did not enter any device information'
      render :new and return
    end
    for serial in @serials do
      line_identifier = @line_identifiers[serial_count]
      @device_identifiers.present? ? device_identifier = @device_identifiers[serial_count] : nil
      next if serial.blank? and line_identifier.blank?
      receiver = AssetReceiver.new contract_end_date: @contract_end_date,
                                   device_model: @device_model,
                                   service_provider: @service_provider,
                                   serial: serial,
                                   line_identifier: line_identifier,
                                   device_identifier: device_identifier,
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
    @device = Device.find params[:id]
    @device_model = @device.device_model
  end

  def update
    @device = Device.find params[:id]
    serial = update_params[:serial]
    identifier = update_params[:device_identifier]
    device_model_id = update_params[:device_model_id]
    Device.update @device.id, serial: serial, identifier: identifier, device_model_id: device_model_id
    if @device.save
      @current_person.log? 'update', @device
      redirect_to @device
      flash[:notice] = 'Device Updated!'
    end
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

  def lost_stolen
    @device = Device.find params[:id]
    lost_stolen_state = DeviceState.find_by name: 'Lost or Stolen'
    if @device.device_states.include? lost_stolen_state
      flash[:error] = 'The device was already reported lost or stolen'
      redirect_to device_path(@device) and return
    end
    if @device.add_state lost_stolen_state
      @current_person.log? 'lost_stolen',
                           @device
      flash[:notice] = 'Device successfully reported as lost or stolen'
      redirect_to device_path(@device)
    else
      flash[:error] = 'Could not set device state to lost or stolen'
      redirect_to device_path(@device)
    end
  end

  def found
    @device = Device.find params[:id]
    lost_stolen_state = DeviceState.find_by name: 'Lost or Stolen'
    if @device.device_states.delete lost_stolen_state
      @current_person.log? 'found',
                           @device
      flash[:notice] = 'Device no longer reported lost or stolen'
      redirect_to device_path(@device)
    else
      flash[:error] = 'Could not remove the lost or stolen state from the device'
      redirect_to device_path(@device)
    end
  end

  def repairing
    @device = Device.find params[:id]
    repairing_state = DeviceState.find_by name: 'Repairing'
    if @device.device_states.include? repairing_state
      flash[:error] = 'The device was already reported as being repaired'
      redirect_to device_path(@device) and return
    end
    if @device.add_state repairing_state
      @current_person.log? 'repairing',
                           @device
      flash[:notice] = 'Device successfully reported as being repaired'
      redirect_to device_path(@device)
    else
      flash[:error] = 'Could not set device state to repairing'
      redirect_to device_path(@device)
    end
  end

  def remove_state
    if @device and @device_state
      deleted = @device.device_states.delete @device_state
      if deleted
        @current_person.log? 'remove_state',
                             @device,
                             @device_state
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
      if @device.add_state @device_state
        @current_person.log? 'add_state',
                             @device,
                             @device_state
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

  def search_bar
    @search = Device.search(params[:q])
  end

  def do_authorization
    authorize Device.new
  end

  def receive_params
    params.permit :contract_end_date, :device_model_id, :technology_service_provider_id, serial: [], line_identifier: [],
                  device_identifier: []
  end

  def update_params
    params.permit :serial, :device_identifier, :device_model_id
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
