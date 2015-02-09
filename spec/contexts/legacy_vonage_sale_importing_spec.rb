require 'rails_helper'

describe LegacyVonageSaleImporting do
  let(:duration) { 5.minutes }
  let!(:person) { create :person, connect_user_id: connect_user.id }
  let(:connect_user) { build_stubbed :connect_user }
  let(:customer_connect_business_partner) {
    build_stubbed :connect_business_partner
  }
  let(:customer_connect_business_partner_location) {
    build_stubbed :connect_business_partner_location,
                  name: '123456',
                  connect_business_partner: customer_connect_business_partner
  }
  let(:connect_business_partner_location) {
    build_stubbed :connect_business_partner_location,
                  c_bpartner_location_id: '123456'
  }
  let(:location) { create :location }
  let(:connect_business_partner) { build_stubbed :connect_business_partner }
  let(:connect_order) {
    build_stubbed :connect_order,
                  salesrep_id: connect_user.id,
                  updated: Time.now - duration + 1.minute
  }
  let(:connect_order_line) { build_stubbed :connect_order_line }
  let(:connect_product) { build_stubbed :connect_product }
  let!(:vonage_product) {
    create :vonage_product,
           name: connect_product.name
  }
  let(:translator) {
    ConnectOrder.new.extend(VonageLegacySaleTranslator)
  }

  before do
    allow(connect_business_partner).to receive(:get_channel).
                                           and_return(location.channel)
    allow(Person).to receive(:return_from_connect_user).
                               and_return(person)
    allow(connect_order).to receive(:connect_order_lines).
                                and_return([connect_order_line])
    allow(connect_order_line).to receive(:connect_product).
                                     and_return(connect_product)
    allow(Location).to receive(:return_from_connect_business_partner_location).
                           and_return(location)
    allow(ConnectBusinessPartnerLocation).to receive(:find_by).
                                                 and_return(connect_business_partner_location)
  end

  describe 'initialization' do
    it 'initializes with a duration' do
      expect {
        LegacyVonageSaleImporting.new duration
      }.not_to raise_error
    end

    it 'throws an error when initialized without arguments' do
      expect {
        LegacyVonageSaleImporting.new
      }.to raise_error(ArgumentError, %r{0 for 1})
    end
  end

  describe 'when translating an order' do
    it 'returns a valid VonageSale' do
      vonage_sale = translator.translate connect_order
      expect(vonage_sale).to be_valid
    end
  end

end