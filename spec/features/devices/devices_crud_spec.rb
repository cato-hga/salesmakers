require 'rails_helper'

describe 'Devices CRUD actions' do
  let!(:it_tech) { create :it_tech_person }
  let(:permission_index) { create :permission, key: 'device_index' }
  let(:permission_new) { create :permission, key: 'device_new' }
  let(:permission_update) { create :permission, key: 'device_update' }
  let(:permission_edit) { create :permission, key: 'device_edit' }
  let(:permission_destroy) { create :permission, key: 'device_destroy' }
  let(:permission_create) { create :permission, key: 'device_create' }
  let(:permission_show) { create :permission, key: 'device_show' }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
  end

  describe 'GET index' do
    let!(:device) { create :device }
    let(:written_off) { create :device_state, name: 'Written Off', locked: true }
    let(:written_off_device) { create :device, serial: '654321', identifier: '654321' }
    before(:each) do
      it_tech.position.permissions << permission_index
      written_off_device.device_states << written_off
      visit devices_path
    end
    it 'should have a link to add new devices' do
      expect(page).to have_content('New')
    end

    it 'has a list of devices' do
      expect(page).to have_content(device.serial)
    end

    # it 'does not have written off devices, by default' do
    #   expect(page).not_to have_content(written_off_device.serial)
    # end
  end

  describe 'GET show' do
    context 'for all devices' do
      let(:device) { create :device }
      before(:each) do
        it_tech.position.permissions << permission_show
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
        expect(page).to have_content(device.device_model_name)
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