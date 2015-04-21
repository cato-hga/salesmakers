require 'rails_helper'

describe ClientRepresentativesController do
  let!(:client_representative) { create :client_representative }

  describe 'GET new_session' do
    before { get :new_session }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new_session template' do
      expect(response).to render_template(:new_session)
    end
  end

  describe 'POST create_session' do
    before do
      post :create_session,
           session: {
               email: client_representative.email,
               password: 'foobar'
           }
    end

    it 'redirects to the welcome action' do
      expect(response).to redirect_to(welcome_client_representatives_path)
    end
  end

  describe 'DELETE destroy_session' do
    before do
      delete :destroy_session
    end

    it 'redirects to new_session' do
      expect(response).to redirect_to(new_session_client_representatives_path)
    end
  end

  describe 'GET welcome' do
    before do
      allow(controller).
          to receive(:current_client_rep).
                 and_return(client_representative)
      get :welcome
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the welcome template' do
      expect(response).to render_template(:welcome)
    end
  end
end