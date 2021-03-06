class DeviceManufacturersController < ApplicationController
  def new
    @device_manufacturer = DeviceManufacturer.new
  end

  def create
    @device_manufacturer = DeviceManufacturer.new create_params
    if @device_manufacturer.save
      @current_person.log? 'create', @device_manufacturer
      flash[:notice] = 'Device manufacturer created!'
      redirect_to new_device_model_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:device_manufacturer).permit(:name)
  end
end
