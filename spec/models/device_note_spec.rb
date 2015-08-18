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

require 'rails_helper'

describe DeviceNote do
end
