require 'rails_helper'

describe ClientAccess::WorkmarketAssignmentsController do
  let!(:client_rep) { create :client_representative, permissions: [permission] }
  let(:permission) { create :permission, key: 'workmarket_assignment_index' }

  before do
    allow(controller).to receive(:current_client_rep).and_return(client_rep)
  end

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

end