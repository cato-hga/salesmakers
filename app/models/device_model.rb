class DeviceModel < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 3 }
  validates :device_manufacturer, presence: true

  belongs_to :device_manufacturer

  def device_model_name
    [device_manufacturer.name, name].join ' '
  end

  def self.policy_class
    DevicePolicy
  end
end
