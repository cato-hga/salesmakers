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

class ComcastInstallAppointment < ActiveRecord::Base
  validates :comcast_sale, presence: true
  validates :comcast_install_time_slot, presence: true
  validates :install_date, presence: true
  validate :install_date_cannot_be_in_the_past

  belongs_to :comcast_sale
  belongs_to :comcast_install_time_slot

  def install_date_cannot_be_in_the_past
    errors.add(:install_date, "cannot be in the past.") if
        install_date and install_date < Date.today
  end
end
