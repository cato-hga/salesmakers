class VonageDevicesController < ApplicationController
  before_action :do_authorization
  after_action :verify_authorized

  def index
    @vonage_device = VonageDevice.all
  end

  def new
    @vonage_device = VonageDevice.new
  end

  def create
    @vonage_device = VonageDevice.new(vonage_device_params)
    if @vonage_device.save
      redirect_to new_vonage_device_path
    else
      render :new
    end
  end

  private

  def vonage_device_params
    params.require(:vonage_device).permit :person_id,
                                          :receive_date,
                                          :mac_id,
                                          :po_number
  end

  def do_authorization
    authorize VonageDevice.new
  end

end