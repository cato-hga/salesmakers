require 'rails_helper'

RSpec.describe 'Asset Receiving' do
  context 'end-to-end operations' do
    let!(:device_model) { create :device_model }
    let!(:service_provider) { create :technology_service_provider }
    let(:line_identifier) { '5555555555' }
    let(:serial) { '123456789' }
    let(:device_identifier) { '98765431' }
    let!(:creator) { create :person }
    let(:contract_end_date) { Date.today + 1.year }
    context 'for single devices' do
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
          expect(page).to have_content(serial)
        end
      end

      context 'failure' do
        context 'assets WITHOUT lines' do
          before {
            visit new_device_path
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

    context 'with secondary identifiers' do

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
        subject {
          visit new_device_path
          fill_in 'Contract End Date', with: contract_end_date.strftime('%m/%d/%Y')
          select device_model.model_name, from: 'Model'
          select service_provider.name, from: 'Service Provider'
          click_on 'Add'
          within('#assets') do
            within all('.row').first do
              find('.serial_field').set(serial)
              find('.line_id_field').set(line_identifier)
            end
            within all('.row').last do
              find('.serial_field').set(second_serial)
              find('.line_id_field').set(second_line_identifier)
            end
          end
          click_on 'Receive'
        }
        it 'receives multiple assets' do
          subject
          visit devices_path
          expect(page).to have_content(serial)
          expect(page).to have_content(second_serial)
        end

        it 'creates all lines' do
          subject
          visit devices_path
          expect(page).to have_content(line_identifier)
          expect(page).to have_content(second_line_identifier)
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