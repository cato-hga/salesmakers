class DirecTVInstallAppointment < ActiveRecord::Base
  validates :directv_sale, presence: true
  validates :directv_install_time_slot, presence: true
  validates :install_date, presence: true

  belongs_to :directv_sale
  belongs_to :directv_install_time_slot
end
