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

end
