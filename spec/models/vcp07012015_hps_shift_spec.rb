# == Schema Information
#
# Table name: vcp07012015_hps_shifts
#
#  id                                  :integer          not null, primary key
#  vonage_commission_period07012015_id :integer          not null
#  shift_id                            :integer          not null
#  person_id                           :integer          not null
#  hours                               :float            not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

require 'rails_helper'

describe VCP07012015HPSShift do
  subject { build :vcp07012015_hps_shift }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a vonage_commission_period07012015' do
    subject.vonage_commission_period07012015 = nil
    expect(subject).not_to be_valid
  end

  it 'requires a shift' do
    subject.shift = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires hours' do
    subject.hours = nil
    expect(subject).not_to be_valid
  end
end
