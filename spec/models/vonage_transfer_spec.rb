# == Schema Information
#
# Table name: vonage_transfers
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  accepted         :boolean          default(FALSE), not null
#  updated_at       :datetime         not null
#  vonage_device_id :integer
#  transfer_time    :datetime
#  rejection_time   :datetime
#  to_person_id     :integer
#  from_person_id   :integer
#  rejected         :boolean          default(FALSE), not null
#

require 'rails_helper'

describe VonageTransfer do
  subject { build :vonage_transfer }

  it 'requires a to person' do
    subject.to_person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a from person' do
    subject.from_person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a vonage device' do
    subject.vonage_device = nil
    expect(subject).not_to be_valid
  end
end
