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
#  person_acknowledged :boolean          default(FALSE)
#  gift_card_number    :string
#  vested              :boolean
#  creator_id          :integer
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
           mac: vonage_mac_prefix.prefix + '123456'
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
           mac: vonage_mac_prefix.prefix + '123459'
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
           mac: vonage_mac_prefix.prefix + '123457'
  }
  let!(:active_status_change) {
    create :vonage_account_status_change,
           mac: active_sale.mac,
           status: :active,
           account_end_date: Date.today + 100.years
  }
  let!(:no_status_sale) {
    create :vonage_sale,
           mac: vonage_mac_prefix.prefix + '123458'
  }
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  let(:kit) { create :vonage_product, name: 'Vonage Whole Home Kit'}

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a valid sale date' do
    subject.sale_date = nil
    expect(subject).not_to be_valid
    subject.sale_date = 'totallywrongdate'
    expect(subject).not_to be_valid
    subject.sale_date = 2.weeks.ago
    expect(subject).not_to be_valid
    subject.sale_date = 13.days.ago
    expect(subject).to be_valid
  end


  it 'requires a confirmation number' do
    subject.confirmation_number = nil
    expect(subject).not_to be_valid
  end

  it 'requires a confirmation number to be 10 characters' do
    subject.confirmation_number = '1234567890'
    expect(subject).to be_valid
    subject.confirmation_number = '123456734'
    expect(subject).not_to be_valid
  end

  it 'requires a MAC' do
    subject.mac = nil
    expect(subject).not_to be_valid
  end

  it 'requires that the MAC have a valid prefix' do
    subject.mac = '101010101010'
    expect(subject).not_to be_valid
    subject.mac = vonage_mac_prefix.prefix.downcase + '101010'
    expect(subject).to be_valid
  end

  it 'does not validate MAC prefixes for Vonage Events sales' do
    events_channel = create :channel, name: 'Vonage Event Teams'
    events_location = create :location, channel: events_channel
    subject.mac = 'ABCDEF123456'
    subject.location = events_location
    expect(subject).to be_valid
  end

  it 'upcases MAC' do
    subject.mac = '906ebb123456'
    expect(subject.mac).to eq('906EBB123456')
  end

  it 'does not allow duplicate MAC ID sales on the same day' do
    duplicate = subject.dup
    duplicate.save
    expect(subject).not_to be_valid
  end

  it 'marks previous sales as having been resold' do
    duplicate = build :vonage_sale
    duplicate.attributes = subject.attributes
    duplicate.sale_date = subject.sale_date - 1.day
    duplicate.save
    subject.save
    duplicate.reload
    subject.reload
    expect(duplicate.resold?).to eq(true)
    expect(subject.resold?).to eq(false)
  end

  it 'requires a customer first name' do
    subject.customer_first_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a customer last name' do
    subject.customer_last_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'requires mac id to be 12 characters (0-9 A-F)' do
    subject.mac = 'ABCDEF123459A'
    expect(subject).not_to be_valid
    subject.mac = vonage_mac_prefix.prefix + '123459'
    expect(subject).to be_valid
  end

  it 'requires a product' do
    subject.vonage_product = nil
    expect(subject).not_to be_valid
  end

  it 'responds to photo' do
    expect(subject).to respond_to :photo
  end

  describe 'gift card check' do
    let(:used_walmart_gift_card) { create :walmart_gift_card, used: true, store_number: walmart_location.store_number }
    let(:used_walmart_gift_card_with_sale_associated) { create :walmart_gift_card, used: true, vonage_sale: create(:vonage_sale) }
    let(:unused_walmart_gift_card) { create :walmart_gift_card, used: true, vonage_sale: create(:vonage_sale) }
    let(:micro_center_location) { create :location, channel: micro_center}
    let(:micro_center) { create :channel, name: 'Micro Center' }
    let(:walmart_location) { create :location, channel: walmart }
    let(:walmart) { create :channel, name: 'Walmart' }
    let!(:gift_card_override) { create :gift_card_override }

    subject { build :vonage_sale, location: walmart_location }

    before do
      # allow(used_walmart_gift_card).to receive(:check).and_return(true)
      # allow(used_walmart_gift_card_with_sale_associated).to receive(:check).and_return(true)
      # allow(unused_walmart_gift_card).to receive(:check).and_return(true)
      allow_any_instance_of(WalmartGiftCard).to receive(:check).and_return(true)
    end

    it 'requires a gift card to be either 12 or 16 characters' do
      subject.vonage_product = kit
      subject.location = micro_center_location
      subject.gift_card_number = 'ab1234567890'
      expect(subject).to be_valid
      subject.location = walmart_location
      subject.gift_card_number = used_walmart_gift_card.card_number
      expect(subject).to be_valid
      subject.location = micro_center_location
      subject.gift_card_number = 'ab12345678901'
      expect(subject).not_to be_valid
    end

    it 'only requires gift card numbers for Walmart and Micro Center' do
      frys_channel = create :channel, name: "Fry's"
      frys_location = create :location, channel: frys_channel
      subject.location = frys_location
      subject.vonage_product = kit
      subject.gift_card_number = nil
      expect(subject).to be_valid
    end

    it 'is invalid when no gift card can be found' do
      expect(subject).not_to be_valid
    end

    it 'is invalid when the gift card has been used and is associated with a VonageSale' do
      subject.gift_card_number = used_walmart_gift_card_with_sale_associated.card_number
      expect(subject).not_to be_valid
    end

    it 'is invalid when the gift card has not been used' do
      subject.gift_card_number = unused_walmart_gift_card.card_number
      expect(subject).not_to be_valid
    end

    it 'is valid when the card has been used and is not yet associated with a VonageSale' do
      subject.gift_card_number = used_walmart_gift_card.card_number
      expect(subject).to be_valid
    end

    it 'validates the gift card location' do
      used_walmart_gift_card.update store_number: 'blah'
      subject.gift_card_number = used_walmart_gift_card.card_number
      expect(subject).not_to be_valid
      used_walmart_gift_card.update store_number: subject.location.store_number
      expect(subject).to be_valid
    end

    it 'validates an override card' do
      subject.gift_card_number = gift_card_override.override_card_number
      expect(subject).to be_valid
    end

    it 'does not allow an override card to be used more than once' do
      create :vonage_sale, gift_card_number: gift_card_override.override_card_number
      subject.gift_card_number = gift_card_override.override_card_number
      expect(subject).not_to be_valid
    end
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

  it 'responds to mac' do
    expect(subject).to respond_to(:mac)
  end

  it 'responds to person_acknowledged' do
    expect(subject).to respond_to(:person_acknowledged)
  end

  it 'responds to creator_id' do
    expect(subject).to respond_to(:creator_id)
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