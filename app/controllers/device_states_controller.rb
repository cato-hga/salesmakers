class DeviceStatesController < ApplicationController
  before_action :check_locked_status, only: [:edit, :update, :destroy]
  before_action :do_authorization
  after_action :verify_authorized

  def index
    @device_states = DeviceState.all
  end

  def new
    @device_state = DeviceState.new
  end

  def create
    @device_state = DeviceState.new device_state_params
    if @device_state.save
      @current_person.log? 'create',
                           @device_state
      flash[:notice] = 'Device State successfully created'
      redirect_to device_states_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @device_state.update device_state_params
      @current_person.log? 'update',
                           @device_state
      flash[:notice] = 'Device State successfully updated'
      redirect_to device_states_path
    else
      render :edit
    end
  end

  def destroy
    if @device_state.destroy
      flash[:notice] = 'Device State successfully deleted'
    end
    redirect_to device_states_path
  end

  private

  def do_authorization
    authorize DeviceState.new
  end

  def device_state_params
    params.require(:device_state).permit :name
  end

  def check_locked_status
    @device_state = DeviceState.find params[:id]
    if @device_state.locked
      flash[:error] = 'That Device State is locked and cannot be edited.'
      redirect_to device_states_path
    end
  end

end