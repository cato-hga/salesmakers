require 'rails_helper'

RSpec.describe 'Asset Receiving' do

  context 'end-to-end operations' do
    context 'for single devices' do
      let!(:device_model) { create :device_model }
      let!(:service_provider) { create :technology_service_provider }
      let(:line_identifier) { '5555555555' }
      let(:serial) { '123456789' }
      let(:device_identifier) { '98765431' }
      let!(:creator) { create :person }
      let(:contract_end_date) { Date.today + 1.year }

      context 'success' do
        subject {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          fill_in 'Serial', with: serial
          fill_in 'Line ID', with: line_identifier
          click_on 'Receive'
        }
        it 'receives an asset' do
          expect { subject }.to change(Device, :count).by(1)
        end

        it 'creates a line' do
          expect { subject }.to change(Line, :count).by(1)
        end

        it 'creates log entries' do
          expect { subject }.to change(LogEntry, :count).by(2)
        end
      end

      context 'failure' do
        subject {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          fill_in 'Serial', with: serial
          fill_in 'Line ID', with: '12345678901'
          click_on 'Receive'
        }

        it 'presents an error when form is invalid' do
          expect { subject }.to raise_error(AssetReceiverValidationException)
        end
      end

      context 'with secondary identifier' do

      end
    end

    context 'for multiple devices' do
      context 'with secondary identifier'
    end
  end
end