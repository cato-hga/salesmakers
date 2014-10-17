class DeviceModel < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 5 }
  validates :device_manufacturer, presence: true

  belongs_to :device_manufacturer

  def model_name
    [device_manufacturer.name, name].join ' '
  end
end
