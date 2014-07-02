class DeviceManufacturer < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }

  has_many :device_models
end
