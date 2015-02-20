class DevicesController < ApplicationController
  include DeviceStateChangesControllerExtension
  include AssetReceiptControllerExtension

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

  private

  def search_bar
    @search = Device.search(params[:q])
  end

  def do_authorization
    authorize Device.new
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

end
