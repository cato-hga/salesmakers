# == Schema Information
#
# Table name: comcast_install_appointments
#
#  id                           :integer          not null, primary key
#  install_date                 :date             not null
#  comcast_install_time_slot_id :integer          not null
#  comcast_sale_id              :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

require 'rails_helper'

describe ComcastInstallAppointment do
end
