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
  validates :mac_id, length: { is: 12 }, confirmation: true, format: { with:/\A[0-9A-F]\z/i }
  validates :receive_date, presence: true

  belongs_to :person

end
