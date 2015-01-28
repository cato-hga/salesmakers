require 'rails_helper'

RSpec.describe 'Asset Receiving' do
  let!(:creator) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  let(:permission_update) { create :permission, key: 'device_update' }
  let(:permission_new) { create :permission, key: 'device_new' }
  let(:permission_create) { create :permission, key: 'device_create' }
  let(:permission_index) { create :permission, key: 'device_index' }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(creator.email)
  end

  context 'end-to-end operations' do
    before(:each) do
      creator.position.permissions << permission_new
      creator.position.permissions << permission_create
      creator.position.permissions << permission_index
    end
    let!(:device_model) { create :device_model }
    let!(:service_provider) { create :technology_service_provider }
    let(:line_identifier) { '5555555555' }
    let(:serial) { '123456789' }
    let(:device_identifier) { '98765431' }
    let(:contract_end_date) { Date.today + 1.year }
    context 'for single devices' do
      context 'success' do
        subject {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.device_model_name, from: 'Model'
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
          expect(page).to have_content(serial)
        end

        it 'should accept a single asset with multiple (blank) rows', js: true do
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.device_model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          find('.serial_field:first-of-type').set(serial)
          find('.line_id_field:first-of-type').set(line_identifier)
          click_on 'Add'
          click_on 'Receive'
          expect(page).to have_content(serial)
          expect(page).not_to have_content('Add Devices')
        end
      end

      context 'failure' do
        context 'no data entered' do
          before {
            visit new_device_path
            click_on 'Receive'
          }

          it 'presents all relevant error messages' do
            expect(page).to have_content('You did not enter any device information')
          end
        end

        context 'assets WITHOUT serials' do
          before {
            visit new_device_path
            find('.line_id_field:first-of-type').set('6666666666')
            click_on 'Receive'
          }

          it 'presents all relevant error messages' do
            expect(page).to have_content('A Device Model is required')
            expect(page).to have_content('A Serial must be present and at least 6 characters in length')
          end
        end

        context 'assets WITH lines' do
          before {
            visit new_device_path
            find('.line_id_field:first-of-type').set('6666666666')
            click_on 'Receive'
          }
          it 'presents all relevant error messages' do
            expect(page).to have_content('A Service Provider is required when Contract End Date and/or Line Identifier is selected')
            expect(page).to have_content('Contract End Date is invalid or incorrectly formatted')
            expect(page).to have_content('A Contract End Date is required when Line Identifier and/or Service Provider is selected')
            expect(page).to have_content('A Device Model is required')
            expect(page).to have_content('A Serial must be present and at least 6 characters in length')
          end
        end
      end
    end

    context 'devices with secondary identifiers' do
      context 'autopopulated' do
        before {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.device_model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          find('.serial_field:first-of-type').set(serial)
          find('.line_id_field:first-of-type').set(line_identifier)
          click_on 'Receive'
        }

        it 'receives the assets with the correct serial and secondary identifier' do
          expect(page).to have_content(serial, count: 2)
        end
      end

      context 'manually entered', js: true do
        before {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.device_model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          click_on 'Manually Set Device Identifier'
          find('.serial_field:first-of-type').set(serial)
          find('.line_id_field:first-of-type').set(line_identifier)
          find('.device_identifier_field:first-of-type').set('85201346')
          click_on 'Receive'
        }

        it 'receives the assets with the correct serial and secondary identifier' do
          expect(page).to have_content(serial, count: 1)
          expect(page).to have_content('85201346', count: 1)
        end
      end
    end

    context 'for multiple devices' do
      describe 'row addition success', js: true do
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

      describe 'device addition success', js: true do
        let(:second_line_identifier) { '6666666666' }
        let(:second_serial) { '987654321' }
        let(:second_identifier) { '8520456789' }
        subject {
          visit new_device_path
          click_on 'Manually Set Device Identifier'
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.device_model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          click_on 'Add'
          within('#assets') do
            within all('.row').first do
              find('.serial_field').set(serial)
              find('.line_id_field').set(line_identifier)
              find('.device_identifier_field').set(device_identifier)
            end
            within all('.row').last do
              find('.serial_field').set(second_serial)
              find('.line_id_field').set(second_line_identifier)
              find('.device_identifier_field').set(second_identifier)
            end
          end
          click_on 'Receive'
        }
        it 'receives multiple assets' do
          subject
          visit devices_path
          expect(page).to have_content(serial)
          expect(page).to have_content(second_serial)
          expect(page).to have_content(second_identifier)
        end

        it 'creates all lines' do
          subject
          visit devices_path
          formatted_identifier = '(' + line_identifier[0..2] + ') ' +
              line_identifier[3..5] + '-' + line_identifier[6..9]
          second_formatted_identifier = '(' + second_line_identifier[0..2] + ') ' +
              second_line_identifier[3..5] + '-' + second_line_identifier[6..9]
          expect(page).to have_content(formatted_identifier)
          expect(page).to have_content(second_formatted_identifier)
        end
      end

      describe 'row deletion', js: true do
        before {
          visit new_device_path
          click_on 'Add'
        }
        it 'deletes the row' do
          expect(page).to have_css('div .serial_field', count: 2)
          click_on 'Delete'
          expect(page).to have_css('div .serial_field', count: 1)
        end
      end
    end
  end
end