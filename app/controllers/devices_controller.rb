class DevicesController < ApplicationController
  include DeviceStateChangesControllerExtension
  include AssetReceiptControllerExtension

  before_action :search_bar, except: [:line_edit]
  before_action :set_models_and_providers, only: [:new, :create, :edit]
  before_action :set_device_and_device_state, only: [:remove_state, :add_state]
  before_action :do_authorization, except: [:show]
  after_action :verify_authorized

  layout 'devices', except: [:line_move_results, :line_move_finalize, :line_swap_results, :line_swap_finalize, :line_swap_or_move, :line_edit]
  layout 'application', only: [:line_move_results, :line_move_finalize, :line_swap_results, :line_swap_finalize, :line_swap_or_move, :line_edit ]

  def index
    authorize Device.new
    @devices = @search.result.includes(:person).includes(:line).order('serial').page(params[:page])
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
    @device_note = DeviceNote.new
    @device_notes = @device.device_notes
    authorize @device
    @unlocked_device_states = DeviceState.where locked: false
    @log_entries = LogEntry.where("(trackable_type = 'Device' AND trackable_id = #{@device.id}) OR (trackable_type = 'Line' AND referenceable_id = #{@device.id}) OR (trackable_type = 'DeviceDeployment' AND referenceable_id = #{@device.id})").order('created_at DESC')
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

  def line_swap_or_move
    @device = Device.find params[:id]
    @devices = @search.result.order('identifier').page(params[:page])
  end

  def line_swap_results
    @device = Device.find params[:id]
    @second_device = Device.find params[:device_id]
  end

  def line_swap_finalize
    @device = Device.find params[:id]
    @second_device = Device.find params[:device_id]
    @line = @device.line if @device.line
    @second_line = @second_device.line
    @device.update line: nil
    @second_device.update line: nil
    if @device.update line: @second_line and @second_device.update line: @line
      @current_person.log? 'line_swap',
                           @device,
                           @line
      @current_person.log? 'line_swap',
                           @second_device,
                           @second_line
      flash[:notice] = 'Lines swapped!'
      redirect_to @device
    else
      render :line_swap_results
    end
  end

  def line_move_results
    @first_device = Device.find params[:id]
    @second_device = Device.find params[:device_id]
  end

  def line_move_finalize
    @first_device = Device.find params[:id]
    @line = @first_device.line
    @second_device = Device.find params[:device_id]
    @first_device.update line: nil
    if @second_device.update line: @line
      @current_person.log? 'line_moved_from',
                           @first_device,
                           @line
      @current_person.log? 'line_moved_to',
                           @second_device,
                           @line
      flash[:notice] = 'Line moved!'
      redirect_to @first_device
    end
  end

  def line_edit
    @line = Line.find params[:line_id]
    devices_without_lines = Device.where(line: nil)
    @search = devices_without_lines.search(params[:q])
    @devices = @search.result.order('serial').page(params[:page])
  end

  def line_update
    line = Line.find params[:line_id]
    device = Device.find params[:id]
    if device.update line: line
    @current_person.log? 'assigned_line',
                         line,
                         device
    flash[:notice] = 'Successfully assigned line to device!'
    redirect_to device
    else
      flash[:error] = 'Line was not assigned to device!'
      redirect_to device
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
    @device_models = DeviceModel.all.joins(:device_manufacturer).order("device_manufacturers.name, name")
    @service_providers = TechnologyServiceProvider.all
  end
end
