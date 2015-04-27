require 'rails_helper'

describe ClientAccess::WorkmarketAssignmentsController do
  let!(:client_rep) { create :client_representative, permissions: [permission_index, permission_show] }
  let(:permission_index) { create :permission, key: 'workmarket_assignment_index' }
  let(:permission_show) { create :permission, key: 'workmarket_assignment_show' }

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

  describe 'GET show' do
    let(:workmarket_assignment) { create :workmarket_assignment }

    before { get :show, id: workmarket_assignment.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the success template' do
      expect(response).to render_template(:show)
    end
  end

end