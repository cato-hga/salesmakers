require 'rails_helper'

describe 'Devices CRUD actions' do

  describe 'GET index' do
    it 'should have a link to add new devices' do
      visit devices_path
      expect(page).to have_content('New')
    end
  end

  describe 'GET show' do
    context 'for all devices' do
      let(:device) { create :device }
      before(:each) do
        visit device_path device
      end
      it 'should have the devices serial number' do
        expect(page).to have_content(device.serial)
      end
      it 'should have a picture of the device' do
        expect(page).to have_css('.device_thumb')
      end
      it 'should have a secondary identifier, if applicable' do
        expect(page).to have_content(device.identifier)
      end
      it 'should have the devices model' do
        expect(page).to have_content(device.model_name)
      end
      it 'should show log entries' do
        expect(page).to have_css('.history')
      end
      it 'should have the option to edit a device' do
        expect(page).to have_content('Edit')
      end
    end

    context 'for deployed devices' do
      let(:deployed_device) { create :device }
      let(:person) { create :person }
      let!(:deployed) { create :device_state, name: 'Deployed' }
      let!(:device_deployment) { create :device_deployment, device: deployed_device, person: person}

      before(:each) do
        deployed_device.device_states << deployed
        visit device_path deployed_device
      end
      it 'should have the "Deployed" state' do
        within('.device_states') do
          expect(page).to have_content('Deployed')
        end
      end
      it 'should show the latest deployment (at least)' do
        within('.deployments') do
          expect(page).to have_content(person.name)
          expect(page).to have_content('to present')
        end
      end
      it 'should have the option to write-off' do
        within('header') do
          within('h1') do
            expect(page).to have_content('Write Off')
          end
        end
      end
      it 'should have the option to recoup' do
        within('header') do
          within('h1') do
            expect(page).to have_content('Recoup')
          end
        end
      end
      it 'should NOT have the option to Deploy' do
        within('header') do
          within('h1') do
            expect(page).not_to have_content('Deploy')
          end
        end
      end
      it 'should have the name of who the asset is deployed to'
      it 'should have the name of who deployed the asset'
    end

    context 'for devices with a line attached' do
      it 'should have the devices line'
      it 'should have the devices line_state'
      it 'should have the devices provider image'
    end

    context 'for devices without a line attached' do
      it 'should display "None" for the line'
    end
  end
end