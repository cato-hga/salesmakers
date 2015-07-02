class DeviceNote < ActiveRecord::Base
  validates :device, presence: true
  validates :person, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :device
  belongs_to :person

  default_scope { order created_at: :desc }
end
