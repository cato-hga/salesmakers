# == Schema Information
#
# Table name: directv_install_appointments
#
#  id                           :integer          not null, primary key
#  directv_install_time_slot_id :integer          not null
#  directv_sale_id              :integer          not null
#  install_date                 :date             not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class DirecTVInstallAppointment < ActiveRecord::Base
  validates :directv_sale, presence: true
  validates :directv_install_time_slot, presence: true
  validates :install_date, presence: true

  belongs_to :directv_sale
  belongs_to :directv_install_time_slot
end
