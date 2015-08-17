class VonageDevicesController < ApplicationController
  before_action :do_authorization
  before_action :chronic_time_zones
  after_action :verify_authorized

  def index
    @vonage_device = VonageDevice.all
  end

  def new
    @vonage_device = VonageDevice.new
  end

  def create
    @vonage_device = VonageDevice.new(vonage_device_params)
    receive_date = params.require(:vonage_device).permit(:receive_date)[:receive_date]
    chronic_time = Chronic.parse(receive_date)
    adjusted_time = chronic_time.present? ? chronic_time.in_time_zone : nil
    @vonage_device.receive_date = adjusted_time
    if @vonage_device.save
      redirect_to new_vonage_device_path
    else
      render :new
    end
  end

  private

  def vonage_device_params
    params.require(:vonage_device).permit :person_id,
                                          :mac_id,
                                          :po_number
  end

  def do_authorization
    authorize VonageDevice.new
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end
end