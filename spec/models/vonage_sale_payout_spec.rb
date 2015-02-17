require 'rails_helper'

describe VonageSalePayout do
  let(:second_paycheck) {
    build :vonage_paycheck,
          wages_start: Date.yesterday,
          wages_end: Date.today,
          commission_start: Date.yesterday,
          commission_end: Date.today,
          cutoff: DateTime.now + 1.day
  }
  subject { build :vonage_sale_payout }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a VonageSale' do
    subject.vonage_sale = nil
    expect(subject).not_to be_valid
  end

  it 'requires a Person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a payout' do
    subject.payout = nil
    expect(subject).not_to be_valid
  end

  it 'requires a VonagePaycheck' do
    subject.vonage_paycheck = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow a duplicate VonageSale and Person combination' do
    subject.save
    duplicate = build :vonage_sale_payout,
                      vonage_paycheck: second_paycheck,
                      person: subject.person,
                      vonage_sale: subject.vonage_sale
    expect(duplicate).not_to be_valid
  end
end