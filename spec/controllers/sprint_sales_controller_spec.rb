require 'rails_helper'

describe SprintSalesController do

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