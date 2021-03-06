# == Schema Information
#
# Table name: vonage_shipped_devices
#
#  id               :integer          not null, primary key
#  active           :boolean          default(TRUE), not null
#  po_number        :string           not null
#  carrier          :string
#  tracking_number  :string
#  ship_date        :date             not null
#  mac              :string           not null
#  device_type      :string
#  vonage_device_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

describe VonageShippedDevice do
  subject { build :vonage_shipped_device }

  it 'requires MAC ID have a valid format' do
    subject.mac = '906EBB12345'
    expect(subject).not_to be_valid
    subject.mac = '906EBB12345G'
    expect(subject).not_to be_valid
    subject.mac = '906ebb123456'
    expect(subject).to be_valid
  end

  it 'upcases MAC IDs' do
    subject.mac = '906ebb123456'
    expect(subject).to be_valid
    expect(subject.mac).to eq('906EBB123456')
  end
end
