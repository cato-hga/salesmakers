require 'rails_helper'

describe LineStatesController do

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:line_state) { build :line_state }

    it 'creates a line state' do
      expect {
        post :create,
             line_state: {
                 name: line_state.name
             }
      }.to change(LineState, :count).by(1)
    end
  end

end