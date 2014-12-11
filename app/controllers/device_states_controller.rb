class DeviceStatesController < ApplicationController

  def index
    @device_states = DeviceState.all
  end

  def new

  end

  def show
    @device_state = DeviceState.find params[:id]
  end

  def edit
    @device_state = DeviceState.find params[:id]
  end
end
