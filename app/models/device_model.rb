# == Schema Information
#
# Table name: device_models
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  device_manufacturer_id :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#

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
