require 'rails_helper'

describe SMSDailyChecksController do

  describe 'GET index' do
    before do
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the edit template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT update' do
    before do
      allow(controller).to receive(:policy).and_return double(update?: true)
    end

    context 'for a new daily check' do
      it 'creates an SMS daily check object'
    end

    context 'for an existing check' do
      it 'deletes the old daily check'
      it ' creates a new daily check'
    end


  end
end