require 'rails_helper'

describe DeviceStatesController do

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
    let(:device_state) { build :device_state }

    it 'creates a device state' do
      expect {
        post :create,
             device_state: {
                 name: device_state.name
             }
      }.to change(DeviceState, :count).by(1)
    end
  end

  describe 'GET edit' do
    context 'for an unlocked device state' do
      let(:device_state) { create :device_state }

      before { get :edit, id: device_state.id }

      it 'returns a success' do
        expect(response).to be_success
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'for a locked device state' do
      let(:device_state) { create :device_state, locked: true }

      it 'redirects when attempting to edit' do
        get :edit,
            id: device_state.id
        expect(response).to redirect_to(device_states_path)
      end
    end
  end

  describe 'PUT update' do
    let(:device_state) { create :device_state }
    let(:new_name) { 'New Name' }

    it 'updates the device state' do
      put :update,
          id: device_state.id,
          device_state: {
              name: new_name
          }
      expect(response).to redirect_to(device_states_path)
    end
  end

  describe 'DELETE destroy' do
    let(:device_state) { create :device_state }

    it 'deletes the device state' do
      delete :destroy,
             id: device_state.id
      expect(page).to redirect_to(device_states_path)
    end
  end
end