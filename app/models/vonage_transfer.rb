# == Schema Information
#
# Table name: vonage_transfers
#
#  id               :integer          not null, primary key
#  to_person        :string
#  from_person      :string
#  vonage_device    :string
#  transfer-time    :datetime         not null
#  created_at       :datetime         not null
#  accepted         :boolean          default(FALSE), not null
#  rejection-time   :datetime         not null
#  updated_at       :datetime         not null
#  vonage_device_id :integer
#

class VonageTransfer < ActiveRecord::Base
  belongs_to :vonage_device
end
