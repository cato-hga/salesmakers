class DeviceState < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }, uniqueness: { case_sensitive: false}
  has_and_belongs_to_many :devices
end
