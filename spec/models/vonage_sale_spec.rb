# == Schema Information
#
# Table name: vonage_sales
#
#  id                  :integer          not null, primary key
#  sale_date           :date             not null
#  person_id           :integer          not null
#  confirmation_number :string           not null
#  location_id         :integer          not null
#  customer_first_name :string           not null
#  customer_last_name  :string           not null
#  mac                 :string           not null
#  vonage_product_id   :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  connect_order_uuid  :string
#  resold              :boolean          default(FALSE), not null
#

require 'rails_helper'


describe VonageSale do
  let(:paycheck) {
    create :vonage_paycheck,
           wages_start: Date.yesterday,
           wages_end: Date.tomorrow,
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
  let(:disconnected_sale) {
    create :vonage_sale,
           mac: 'ABCDEF123456'
  }
  let!(:disconnected_status_change) {
    create :vonage_account_status_change,
           mac: disconnected_sale.mac,
           status: :terminated,
           account_end_date: Date.today - 1.week,
           termination_reason: 'You suck'
  }
  let(:disconnected_after_date_sale) {
    create :vonage_sale,
           mac: 'ABCDEF123459'
  }
  let!(:disconnected_after_date_status_change) {
    create :vonage_account_status_change,
           mac: disconnected_after_date_sale.mac,
           status: :terminated,
           account_end_date: Date.today,
           termination_reason: 'You really suck'
  }
  let(:active_sale) {
    create :vonage_sale,
           mac: 'ABCDEF123457'
  }
  let!(:active_status_change) {
    create :vonage_account_status_change,
           mac: active_sale.mac,
           status: :active,
           account_end_date: Date.today + 100.years
  }
  let!(:no_status_sale) {
    create :vonage_sale,
           mac: 'ABCDEF123458'
  }

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

  it 'requires gift card rules and regulations to be checked for sale completion' do
    subject.person_acknowledged = false
    expect(subject).not_to be_valid
  end

  it 'gets sales for a paycheck' do
    subject.save
    expect(described_class.for_paycheck(paycheck).count).to eq(5)
    expect(described_class.for_paycheck(old_paycheck).count).to eq(0)
  end

  it 'responds to connect_order' do
    expect(subject).to respond_to(:connect_order)
  end

  it 'responds to gift_card_number' do
    expect(subject).to respond_to(:gift_card_number)
  end

  it 'responds to person_acknowledged' do
    expect(subject).to respond_to(:person_acknowledged)
  end

  describe 'still active checks' do
    it 'returns false if disconnected before date' do
      expect(disconnected_sale.still_active_on?(Date.today - 3.days)).to be_falsey
    end

    it 'returns true if disconnected after date' do
      expect(disconnected_after_date_sale.still_active_on?(Date.today - 3.days)).to be_truthy
    end

    it 'returns true if still active' do
      expect(active_sale.still_active_on?(Date.today - 3.days)).to be_truthy
    end

    it 'returns false if no status change' do
      expect(no_status_sale.still_active_on?(Date.today - 3.days)).to be_falsey
    end
  end
end
