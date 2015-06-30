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
  subject { build :comcast_install_appointment }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a ComcastInstallTimeSlot' do
    subject.comcast_install_time_slot = nil
    expect(subject).not_to be_valid
  end

  it 'requires a ComcastSale' do
    subject.comcast_sale = nil
    expect(subject).not_to be_valid

  end

  it 'requires an install date' do
    subject.install_date = nil
    expect(subject).not_to be_valid
  end
end
