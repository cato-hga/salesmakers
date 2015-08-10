# == Schema Information
#
# Table name: device_notes
#
#  id         :integer          not null, primary key
#  device_id  :integer
#  note       :text
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DeviceNote < ActiveRecord::Base
  validates :device, presence: true
  validates :person, presence: true
  validates :note, length: { minimum: 5 }

  belongs_to :device
  belongs_to :person

  default_scope { order created_at: :desc }
end
