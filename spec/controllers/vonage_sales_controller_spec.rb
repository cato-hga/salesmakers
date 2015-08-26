require 'rails_helper'

describe VonageSalesController do
  let!(:project) { create :project, name: 'Vonage Retail' }
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  let(:rep) { create :person, position: position }
  let(:gift_card_override) { create :gift_card_override }
  let!(:rep_vonage_sale) { create :vonage_sale, person: rep, vested: true, gift_card_number: gift_card_override.override_card_number }
  let(:position) { create :position, permissions: [index_permission] }
  let(:index_permission) { create :permission, key: 'vonage_sale_index' }

  before { CASClient::Frameworks::Rails::Filter.fake(rep.email) }

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end
end