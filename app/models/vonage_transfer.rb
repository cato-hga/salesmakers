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
#

class VonageTransfer < ActiveRecord::Base
  belongs_to :vonage_device
  belongs_to :to_person, class_name: 'Person'
  belongs_to :from_person, class_name: 'Person'

  def self.policy_class
    VonageDevicePolicy
  end
end
