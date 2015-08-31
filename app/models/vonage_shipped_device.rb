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
