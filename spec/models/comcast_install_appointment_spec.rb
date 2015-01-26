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