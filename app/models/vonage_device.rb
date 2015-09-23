# == Schema Information
#
# Table name: vonage_devices
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  mac_id       :string
#  po_number    :string
#  person_id    :integer
#  receive_date :datetime
#

class VonageDevice < ActiveRecord::Base

  validates :po_number, format: { with: /\A([0-9A-Z]{16}|[0-9A-Z]{12})\z/i }
  validates :po_number, presence: true
  validates :mac_id, format: { with:/\A[0-9A-F]{12}\z/i }
  validates :mac_id, uniqueness: true
  validates :mac_id, presence: true
  validates :receive_date, presence: true

  belongs_to :person
  has_many :vonage_transfers

  before_validation :upcase_mac_id

  private

  def upcase_mac_id
    self.mac_id = self.mac_id.upcase if self.mac_id
  end
end
