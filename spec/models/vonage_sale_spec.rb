require 'rails_helper'

describe VonageSale do
  let(:paycheck) {
    create :vonage_paycheck,
           commission_start: Date.yesterday,
           commission_end: Date.tomorrow,
           cutoff: DateTime.now + 2.days
  }
  let(:old_paycheck) {
    create :vonage_paycheck,
           name: 'Old Paycheck',
           wages_start: paycheck.wages_start - 4.weeks,
           wages_end: paycheck.wages_end - 4.weeks,
           commission_start: paycheck.commission_start - 4.weeks,
           commission_end: paycheck.commission_end - 4.weeks,
           cutoff: DateTime.now + 3.days - 4.weeks
  }
  subject { build :vonage_sale, sale_date: Date.today }

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

  it 'requires a MAC' do
    subject.mac = nil
    expect(subject).not_to be_valid
  end

  it 'requires a product' do
    subject.vonage_product = nil
    expect(subject).not_to be_valid
  end

  it 'gets sales for a paycheck' do
    subject.save
    expect(described_class.for_paycheck(paycheck).count).to eq(1)
    expect(described_class.for_paycheck(old_paycheck).count).to eq(0)
  end
end