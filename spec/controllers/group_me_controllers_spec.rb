require 'rails_helper'

describe GroupMesController do
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET auth_page' do
    before do
      get :auth_page
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the auth_Page template' do
      expect(response).to render_template(:auth_page)
    end
  end
end