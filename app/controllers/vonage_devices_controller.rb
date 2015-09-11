class VonageDevicesController < ApplicationController
  before_action :do_authorization
  before_action :chronic_time_zones
  after_action :verify_authorized

  def index
    @vonage_devices = VonageDevice.all
  end

  def new
    @vonage_device = VonageDevice.new

  end

  def transfer
    @vonage_transfer = VonageTransfer.new
    set_vonage_employees
    @vonage_devices = @current_person.vonage_devices
  end


  def do_transfer
    to_person = Person.find params[:to_person]
    vonage_device_ids = params[:vonage_devices]
    invalids = 0
    invalid_macs = []
    for device in vonage_device_ids do
      vonage_device = VonageDevice.find device
      transfer = VonageTransfer.new to_person: to_person,
                                    from_person: @current_person,
                                    vonage_device: vonage_device,
                                    transfer_time: DateTime.now
      if transfer.save
        vonage_device.update person: to_person
      else
        invalid_macs << vonage_device.mac_id
        invalids += 1
      end
    end
    if invalids = 0
      #SUCCESS
      redirect_to transfer_vonage_devices_path
    else
      flash[:error] = "The following MAC ID's could not be transferred. Please submit a support ticket with a screenshot of this page. #{invalid_macs.join(', ')}"
      redirect_to transfer_vonage_devices_path
    end
  end

  def create
    @vonage_device = VonageDevice.new
    @vonage_transfer = VonageTransfer.new
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
      redirect_to transfer_vonage_devices_path
    else
      render :new
    end
  end

  private

  def set_vonage_employees
    @vonage_employees = @current_person.managed_team_members.sort_by { |n| n[:display_name] }
  end

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