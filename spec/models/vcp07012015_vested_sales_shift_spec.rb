require 'rails_helper'

describe VCP07012015VestedSalesShift do
  subject { build :vcp07012015_vested_sales_shift }

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