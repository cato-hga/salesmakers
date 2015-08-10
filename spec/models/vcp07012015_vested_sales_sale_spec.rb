require 'rails_helper'

describe VCP07012015VestedSalesSale do
  subject { build :vcp07012015_vested_sales_sale }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a vonage_commission_period07012015' do
    subject.vonage_commission_period07012015 = nil
    expect(subject).not_to be_valid
  end

  it 'requires a vonage_sale' do
    subject.vonage_sale = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a vested boolean value' do
    subject.vested = nil
    expect(subject).not_to be_valid
  end
end
