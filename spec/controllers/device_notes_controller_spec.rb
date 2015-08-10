require 'rails_helper'

describe DeviceNotesController do
  let(:it_tech) { create :it_tech_person}
  let!(:device) { create :device }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  describe 'POST create' do
    before do
      post :create,
           device_id: device.id,
           device_note: {
              note: 'This is a note'
           }
    end

    it 'redirects to the device show page' do
      expect(response).to redirect_to(device_path(device))
    end

    it 'increases the DeviceNote count' do
      expect(DeviceNote.count).to eq(1)
    end
  end
end