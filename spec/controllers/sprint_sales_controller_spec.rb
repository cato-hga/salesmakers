require 'rails_helper'

describe SprintSalesController do

  let!(:project) { create :project, name: 'Sprint Prepaid' }
  let(:rep) { create :person, position: position }
  let!(:rep_sprint_sale) { create :sprint_sale, person: rep }
  let(:position) { create :position, permissions: [index_permission] }
  let(:index_permission) { create :permission, key: 'sprint_sale_index' }

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

  describe 'GET csv' do
    before { get :csv }

    it 'returns a redirect status' do
      expect(response).to be_redirect
    end
  end

  describe 'GET show' do
    before { get :show, id: rep_sprint_sale.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET scoreboard' do
    let!(:client) { create :client, name: 'Sprint' }
    context 'with permission' do
      before do
        allow(controller).to receive(:policy).and_return double(scoreboard?: true)
        get :scoreboard
      end

      it 'returns a success status' do
        expect(response).to be_success
      end

      it 'renders the scoreboard template' do
        expect(response).to render_template(:scoreboard)
      end
    end

    context 'without permission' do
      before do
        allow(controller).to receive(:policy).and_return double(scoreboard?: false)
        get :scoreboard
      end

      it 'returns an other-than-success status' do
        expect(response).not_to be_success
      end
    end
  end
end