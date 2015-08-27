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
    @vonage_device = VonageDevice.new
    receive_date = params.permit(:receive_date)[:receive_date]
    chronic_time = Chronic.parse(receive_date)
    adjusted_time = chronic_time.present? ? chronic_time.in_time_zone : nil
    po_number = vonage_device_params[:po_number]
    mac_ids = vonage_device_params[:mac_id]
    @vonage_device_ids = []
    for mac_id in mac_ids do
      vonage_device = VonageDevice.create person: @current_person,
                                          po_number: po_number,
                                          receive_date: adjusted_time,
                                          mac_id: mac_id
      @vonage_device_ids << vonage_device.id
    end
    @vonage_device_ids.compact!
    unless @vonage_device_ids.empty?
      VonageInventoryMailer.inventory_receiving_mailer(@current_person, @vonage_device_ids).deliver_later
      redirect_to new_vonage_transfer_path
    else
      render :new
    end
  end

  private

  def vonage_device_params
    params.permit :person_id,
                  :po_number,
                  mac_id: []

  end

  def do_authorization
    authorize VonageDevice.new
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end
end