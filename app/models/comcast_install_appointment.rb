class ComcastInstallAppointment < ActiveRecord::Base
  validates :comcast_sale, presence: true
  validates :comcast_install_time_slot, presence: true
  validates :install_date, presence: true

  belongs_to :comcast_sale
  belongs_to :comcast_install_time_slot
end
