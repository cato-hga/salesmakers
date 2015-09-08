require 'rails_helper'

describe 'gift cards' do
  # TODO: Reimplement when Vonage done
  # let!(:it_tech) { create :it_tech_person, position: position }
  # let(:position) { create :it_tech_position, permissions: [gift_card_override_create] }
  # let(:gift_card_override_create) { create :permission, key: 'gift_card_override_create' }
  # let(:person) { create :person }
  #
  # before do
  #   CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  # end
  #
  # context 'for override cards' do
  #   let(:gift_card_override) { build :gift_card_override }
  #   before { visit person_path(person) }
  #
  #   it 'generates an override card' do
  #     click_on 'Override Card'
  #     fill_in 'Original card number', with: gift_card_override.original_card_number
  #     click_on 'Generate'
  #     expect(page).to have_selector '#override_card_number'
  #     expect(GiftCardOverride.count).to eq(1)
  #     expect(LogEntry.where("trackable_type = 'GiftCardOverride'").count).to eq(1)
  #   end
  # end
end