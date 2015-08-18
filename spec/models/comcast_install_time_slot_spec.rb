# == Schema Information
#
# Table name: comcast_install_time_slots
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe ComcastInstallTimeSlot do
end
