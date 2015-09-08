# == Schema Information
#
# Table name: vonage_shipped_devices
#
#  id               :integer          not null, primary key
#  active           :boolean          default(TRUE), not null
#  po_number        :string           not null
#  carrier          :string
#  tracking_number  :string
#  ship_date        :date             not null
#  mac              :string           not null
#  device_type      :string
#  vonage_device_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class VonageShippedDevice < ActiveRecord::Base
  before_validation :upcase_mac

  validates :active, inclusion: { in: [true, false] }
  validates :po_number, presence: true
  validates :ship_date, presence: true
  validates :mac, format: /\A[0-9A-Fa-f]{12}\Z/

  private

  def upcase_mac
    self.mac = self.mac.upcase if mac
  end
end
