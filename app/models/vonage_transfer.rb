# == Schema Information
#
# Table name: vonage_transfers
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  accepted         :boolean          default(FALSE), not null
#  updated_at       :datetime         not null
#  vonage_device_id :integer
#  transfer_time    :datetime
#  rejection_time   :datetime
#  to_person_id     :integer
#  from_person_id   :integer
#  rejected         :boolean          default(FALSE), not null
#

class VonageTransfer < ActiveRecord::Base

  validates :vonage_device, presence: true
  validates :from_person, presence: true, on: :do_transfer
  validates :to_person, presence: true
  
  belongs_to :vonage_device
  belongs_to :to_person, class_name: 'Person'
  belongs_to :from_person, class_name: 'Person'

  def self.policy_class
    VonageDevicePolicy
  end
end
