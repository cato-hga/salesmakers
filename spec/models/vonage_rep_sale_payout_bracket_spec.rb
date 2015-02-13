require 'rails_helper'

describe VonageRepSalePayoutBracket do
  subject { build :vonage_rep_sale_payout_bracket }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a per-sale amount' do
    subject.per_sale = nil
    expect(subject).not_to be_valid
  end

  it 'requires an area' do
    subject.area = nil
    expect(subject).not_to be_valid
  end

  it 'requires a minimum sale amount' do
    subject.sales_minimum = nil
    expect(subject).not_to be_valid
  end

  it 'requires a maximum sale amount' do
    subject.sales_maximum = nil
    expect(subject).not_to be_valid
  end

  describe 'uniqueness validations' do
    let(:duplicate) { build :vonage_rep_sale_payout_bracket }

    before { subject.save }

    it 'does not allow duplicate minimum sale amounts' do
      duplicate.sales_maximum += 1
      expect(duplicate).not_to be_valid
    end

    it 'does not allow duplicate maximum sale amounts' do
      duplicate.sales_minimum += 1
      expect(duplicate).not_to be_valid
    end
  end

end