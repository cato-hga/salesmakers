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
          find('.serial_field:first-of-type').set(serial)
          find('.line_id_field:first-of-type').set(line_identifier)
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

        it 'should redirect to devices#index' do
          subject
          expect(page).to have_content('records found')
        end
      end

      context 'failure' do
        subject {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          find('.serial_field:first-of-type').set(serial)
          find('.line_id_field:first-of-type').set('12345678901')
          click_on 'Receive'
        }
      end

      context 'with secondary identifier' do

      end
    end

    context 'for multiple devices' do
      describe 'row addition', js: true do
        before {
          visit new_device_path
          click_on 'Add'
        }

        it 'should add additional lines' do
          expect(page).to have_css('div .serial_field', count: 2)
        end

        it 'should change the Add button to Delete for all but the last row' do
          within('#assets .row:first-of-type') do
            expect(page).to have_selector('.delete_row')
          end
          within('#assets .row:last-of-type') do
            expect(page).to have_selector('.add_row')
          end
        end
      end
    end
  end
end