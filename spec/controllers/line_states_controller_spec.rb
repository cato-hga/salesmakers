require 'rails_helper'

describe DeviceStatesController do


  describe 'GET index' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:device_state) { build :device_state }
    let!(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(create?: true)
    end
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

      before {
        allow(controller).to receive(:policy).and_return double(edit?: true)
        get :edit, id: device_state.id }

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
    let!(:person) { create :it_tech_person }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(update?: true)
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
    end
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
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: device_state.id
      expect(response).to redirect_to(device_states_path)
    end
  end
end