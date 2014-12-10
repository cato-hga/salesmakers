require 'rails_helper'

RSpec.describe 'Asset Receiving' do

  context 'end-to-end operation' do
    let(:device_model) { create :device_model }
    let(:service_provider) { create :technology_service_provider }
    let(:line_identifier) { '5555555555' }
    let(:serial) { '123456789' }
    let(:device_identifier) { '98765431' }
    let(:creator) { create :person }
    let(:contract_end_date) { Date.today + 1.year }

    it 'receives an asset' do
      visit new_device_path
      fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
      select device_model.name, from: 'Model'
      select service_provider.name, from: 'Service Provider'
      fill_in 'Serial', with: serial
      fill_in 'Line ID', with: line_identifier

      expect { click_on 'Receive' }.to change(Device, :count).by(1)
    end
    it 'presents an error when form is invalid'

    context 'with secondary identifier' do

    end
  end
end