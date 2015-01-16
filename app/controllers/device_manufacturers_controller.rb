class DeviceManufacturersController < ApplicationController
  def new
    @device_manufacturer = DeviceManufacturer.new
  end

  def create
  end
end
