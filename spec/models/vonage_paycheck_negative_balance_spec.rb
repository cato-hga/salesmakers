require 'rails_helper'

describe VonagePaycheckNegativeBalance do
  subject { build :vonage_paycheck_negative_balance }

  it 'is correct with valid attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a balance' do
    subject.balance = nil
    expect(subject).not_to be_valid
  end

  it 'requires a vonage_paycheck' do
    subject.vonage_paycheck = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow duplicate person and vonage_paycheck combos' do
    subject.save
    new_balance = build :vonage_paycheck_negative_balance,
                        person: subject.person,
                        balance: -10.00,
                        vonage_paycheck: subject.vonage_paycheck
    expect(new_balance).not_to be_valid
  end
end