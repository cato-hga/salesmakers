class DeviceManufacturer < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  has_many :device_models
end
