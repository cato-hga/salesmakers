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

  describe 'GET edit' do
    context 'for an unlocked line state' do
      let(:line_state) { create :line_state }

      before { get :edit, id: line_state.id }

      it 'returns a success' do
        expect(response).to be_success
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'for a locked line state' do
      let(:line_state) { create :line_state, locked: true }

      it 'redirects when attempting to edit' do
        get :edit,
            id: line_state.id
        expect(response).to redirect_to(line_states_path)
      end
    end
  end

  describe 'PUT update' do
    let(:line_state) { create :line_state }
    let(:new_name) { 'New Name' }

    it 'updates the line state' do
      put :update,
          id: line_state.id,
          line_state: {
              name: new_name
          }
      expect(response).to redirect_to(line_states_path)
    end
  end

end