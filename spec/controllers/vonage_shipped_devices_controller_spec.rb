require 'rails_helper'

describe VonageShippedDevicesController do
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [create_permission] }
  let(:create_permission) { create :permission, key: 'vonage_shipped_device_create' }

  before { CASClient::Frameworks::Rails::Filter.fake(person.email) }

  describe 'GET new' do
    it 'returns a success status' do
      get :new
      expect(response).to be_success
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'does not allow those without permission to access the page' do
      position.permissions.delete create_permission
      get :new
      expect(response).not_to be_success
    end
  end

  describe 'POST create' do
    let(:json) {
      {
          data: [
              [
                  "5075",
                  "20158992",
                  "RBD-Edison S T",
                  "LTL",
                  "BBB100223571",
                  "8/25/2015",
                  "346895256A61",
                  "VDV23-CVR"
              ],
              [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
      }.to_json
    }

    before { post :create, vonage_shipped_devices_json: json }

    it 'creates the VonageShippedDevices' do
      expect(VonageShippedDevice.count).to eq(1)
    end

    it 'creates a LogEntry' do
      expect(LogEntry.where(trackable_type: 'VonageShippedDevice').count).to eq(1)
    end
  end
end