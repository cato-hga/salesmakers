# == Schema Information
#
# Table name: device_manufacturers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class DeviceManufacturer < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  has_many :device_models

  strip_attributes
end
