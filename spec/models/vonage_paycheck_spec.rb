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
    let(:person) {
      create :person
    }

    it 'returns the correct net payout amount' do
      expect(subject.net_payout(person)).to eq(0.00)
    end
  end

end