module DevicesHelper

  def cache_key_for_devices(page = nil)
    if Device.count < 1 || Person.count < 1
      return "devices#index-#{DateTime.now.to_s(:number)}"
    end
    page = page ? page : '0'
    "devices#index-#{page}-#{DeviceDeployment.maximum(:updated_at)}-#{Device.maximum(:updated_at).try(:to_s, :number)}-#{Person.maximum(:updated_at).try(:to_s, :number)}"
  end
end
