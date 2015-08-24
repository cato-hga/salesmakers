require 'rails_helper'

describe WalmartGiftCardsController do
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [create_permission] }
  let(:create_permission) { create :permission, key: 'walmart_gift_card_create' }

  before { CASClient::Frameworks::Rails::Filter.fake(person.email) }

  describe 'GET new' do
    it 'returns a success status' do
      get :new
      expect(response).to be_success
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'does not allow those without permission to access the page' do
      position.permissions.delete create_permission
      get :new
      expect(response).not_to be_success
    end
  end

  describe 'POST create' do
    let(:json) {
      {
          data: [
              [
                  "https://getegiftcard.walmart.com/gift-card/view/DS0ztiDNi8aFMY6tPPilxqDqT/",
                  "PNK2PV",
                  "6084831410224511",
                  "147",
                  ""
              ],
              [nil, nil, nil, nil, nil]
          ]
      }.to_json
    }

    before { post :create, gift_card_json: json }

    it 'prepares the proper number of gift cards' do
      expect(assigns(:gift_card_attributes).count).to eq(1)
    end

    it 'successfully fires off the check job' do
      expect(flash[:notice]).to include 'Cards submitted. Your cards should arrive at around'
    end
  end
end