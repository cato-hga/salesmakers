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

  describe 'GET new_override' do
    let(:other_person) { create :person }

    context 'without permission' do
      before { get :new_override, person_id: other_person.id }

      it 'does not allow access' do
        expect(response).to have_http_status(403)
      end
    end

    context 'with permission' do
      before do
        person.position.permissions << create(:permission, key: 'gift_card_override_create')
        get :new_override, person_id: other_person.id
      end

      it 'returns a success response' do
        expect(response).to be_success
      end

      it 'renders the new_override template' do
        expect(response).to render_template :new_override
      end

      context 'issuing to self' do
        before { get :new_override, person_id: person.id }

        it 'is not allowed' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe 'POST create_override' do
    let(:other_person) { create :person }
    let(:gift_card_override) { build :gift_card_override }

    before do
      person.position.permissions << create(:permission, key: 'gift_card_override_create')
      post :create_override,
           gift_card_override: {
               person_id: other_person.id,
               creator_id: person.id,
               original_card_number: gift_card_override.original_card_number
           }
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the create_override template' do
      expect(response).to render_template :create_override
    end

    it 'increases the GiftCardOverride count' do
      expect(GiftCardOverride.count).to eq(1)
    end
  end

  describe 'POST create', :vcr do
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