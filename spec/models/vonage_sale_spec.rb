require 'rails_helper'

describe VonageSale do
  subject { build :vonage_sale }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a sale date' do
    subject.sale_date = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a confirmation number' do
    subject.confirmation_number = nil
    expect(subject).not_to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'requires a customer first name' do
    subject.customer_first_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a customer last name' do
    subject.customer_last_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a MAC ID' do
    subject.mac_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a product' do
    subject.vonage_product = nil
    expect(subject).not_to be_valid
  end

end