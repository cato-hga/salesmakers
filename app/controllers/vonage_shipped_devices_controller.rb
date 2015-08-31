class VonageShippedDevicesController < ApplicationController
  after_action :verify_authorized

  def new
    authorize VonageShippedDevice.new
  end

  def create
    authorize VonageShippedDevice.new
    data = JSON.parse params[:vonage_shipped_devices_json]
    unless data && data['data']
      flash[:error] = 'Data did not submit successfully. Please contact support.'
      redirect_to new_vonage_shipped_device_path and return
    end
    data = data['data']
    @vonage_shipped_devices_attributes = []
    for atts in data do
      po_number,
          carrier,
          tracking_number,
          ship_date,
          mac,
          device_type =
          atts[1],
              atts[3],
              atts[4],
              atts[5],
              atts[6],
              atts[7]
      po_number = nil if po_number == ''
      carrier = nil if carrier == ''
      tracking_number = nil if tracking_number == ''
      ship_date = Chronic.parse(ship_date)
      mac = nil if mac == ''
      device_type = nil if device_type == ''
      next unless po_number && ship_date && mac
      device = VonageShippedDevice.find_or_initialize_by mac: mac
      device.attributes = {
          po_number: po_number,
          carrier: carrier,
          tracking_number: tracking_number,
          ship_date: ship_date,
          mac: mac,
          device_type: device_type
      }
      if device.save
        @current_person.log? 'create',
                             device
      end
    end
    flash[:notice] = "Devices imported successfully."
    redirect_to new_vonage_shipped_device_path
  end
end
