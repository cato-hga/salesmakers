class DeviceModel < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 5 }
  validates :device_manufacturer, presence: true

  belongs_to :device_manufacturer
end
