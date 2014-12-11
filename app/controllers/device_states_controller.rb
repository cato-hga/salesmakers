class DeviceStatesController < ApplicationController

  def index
    @device_states = DeviceState.all
  end

  def new

  end
end
