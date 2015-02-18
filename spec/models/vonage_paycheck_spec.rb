require 'rails_helper'

describe VonagePaycheck do
  subject { build :vonage_paycheck }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a wages start date' do
    subject.wages_start = nil
    expect(subject).not_to be_valid
  end

  it 'requires a wages end date' do
    subject.wages_end = nil
    expect(subject).not_to be_valid
  end

  it 'requires a commission start date' do
    subject.commission_start = nil
    expect(subject).not_to be_valid
  end

  it 'requires a commission end date' do
    subject.commission_end = nil
    expect(subject).not_to be_valid
  end

  it 'requires a cutoff date and time' do
    subject.cutoff = nil
    expect(subject).not_to be_valid
  end

  it 'requires wages_end to be after wages_start' do
    subject.wages_end = subject.wages_start - 1.day
    expect(subject).not_to be_valid
  end

  it 'requires commission_end to be after commission_start' do
    subject.commission_end = subject.commission_start - 1.day
    expect(subject).not_to be_valid
  end

  it 'requires that the cutoff be after wages_end' do
    subject.cutoff = subject.wages_end.to_time - 1.day
    expect(subject).not_to be_valid
  end

  it 'requires that the cutoff be after commission_end' do
    subject.cutoff = subject.commission_end.to_time - 1.day
    expect(subject).not_to be_valid
  end

  describe 'nearby paychecks' do
    let!(:future_paycheck) {
      create :vonage_paycheck,
             name: 'Future Paycheck',
             wages_start: subject.wages_start + 4.weeks,
             wages_end: subject.wages_end + 4.weeks,
             commission_start: subject.commission_start + 4.weeks,
             commission_end: subject.commission_end + 4.weeks,
             cutoff: subject.cutoff + 4.weeks + 1.day
    }
    let!(:old_paycheck) {
      create :vonage_paycheck,
             name: 'Old Paycheck',
             wages_start: subject.wages_start - 4.weeks,
             wages_end: subject.wages_end - 4.weeks,
             commission_start: subject.commission_start - 4.weeks,
             commission_end: subject.commission_end - 4.weeks,
             cutoff: subject.cutoff - 4.weeks + 1.day
    }

    it 'returns the previous paycheck' do
      expect(subject.get_previous).to eq(old_paycheck)
    end

    it 'returns the next paycheck' do
      expect(subject.get_next).to eq(future_paycheck)
    end
  end

  describe 'uniqueness validations' do
    let(:another) { build :another_vonage_paycheck }

    before { subject.save }

    it 'does not allow another names' do
      another.name = subject.name
      expect(another).not_to be_valid
    end

    it 'does not allow another wages start dates' do
      another.wages_start = subject.wages_start
      expect(another).not_to be_valid
    end

    it 'does not allow another wages end dates' do
      another.wages_end = subject.wages_end
      expect(another).not_to be_valid
    end

    it 'does not allow another commission start dates' do
      another.commission_start = subject.commission_start
      expect(another).not_to be_valid
    end

    it 'does not allow another commission end dates' do
      another.commission_end = subject.commission_end
      expect(another).not_to be_valid
    end

    it 'does not allow a wages start date within the range of another paycheck' do
      another.wages_start = subject.wages_start + 1.day
      expect(another).not_to be_valid
    end

    it 'does not allow a wages end date within the range of another paycheck' do
      another.wages_end = subject.wages_end - 1.day
      another.wages_start = subject.wages_start - 1.day
      expect(another).not_to be_valid
    end

    it 'does not allow a commission start date within the range of another paycheck' do
      another.commission_start = subject.commission_start + 1.day
      expect(another).not_to be_valid
    end

    it 'does not allow a commission end date within the range of another paycheck' do
      another.commission_end = subject.commission_end - 1.day
      another.commission_start = subject.commission_start - 1.day
      expect(another).not_to be_valid
    end
  end

  describe 'scopes' do
    let!(:vonage_sale_payout) {
      subject.save
      create :vonage_sale_payout,
             vonage_paycheck: subject,
             person: person
    }
    let!(:vonage_refund) {
      create :vonage_refund,
             refund_date: subject.commission_end - 2.days,
             vonage_sale: vonage_sale_payout.vonage_sale,
             person: person
    }
    let!(:vonage_paycheck_negative_balance) {
      create :vonage_paycheck_negative_balance,
             person: person,
             vonage_paycheck: subject,
             balance: -50.00
    }
    let(:person) {
      create :person
    }

    it 'returns the correct net payout amount' do
      expect(subject.net_payout(person)).to eq(-50.00)
    end

    it 'returns refunds for a paycheck for a person' do
      expect(subject.refunds_for_person(person).count).to eq(1)
    end

    it 'returns payouts for a paycheck for a person' do
      expect(subject.payouts_for_person(person).count).to eq(1)
    end

    it 'returns negative paycheck balances for a person' do
      expect(subject.negative_balance_for_person(person)).to eq(-50.00)
    end

    it 'returns all refunds for a paycheck' do
      expect(subject.refunds.count).to eq(1)
    end
  end
end