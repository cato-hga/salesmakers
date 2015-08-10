require 'rails_helper'

describe 'Devices CRUD actions' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_index, permission_create] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'device_index', permission_group: permission_group, description: description }
  let(:permission_new) { Permission.new key: 'device_new', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'device_update', permission_group: permission_group, description: description }
  let(:permission_edit) { Permission.new key: 'device_edit', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'device_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'device_create', permission_group: permission_group, description: description }
  let(:permission_show) { Permission.new key: 'device_show', permission_group: permission_group, description: description }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  describe 'GET index' do
    let!(:device) { create :device, device_states: [written_off] }
    let(:written_off) { create :device_state, name: 'Written Off', locked: true }
    let(:written_off_device) { create :device, serial: '654321', identifier: '654321' }
    before(:each) do
      visit devices_path
    end
    it 'should have a link to add new devices' do
      expect(page).to have_content('New')
    end

    it 'has a list of devices' do
      expect(page).to have_content(device.serial)
    end

  end

  describe 'GET show' do
    context 'for all devices' do
      let(:device) { create :device, line: line }
      let(:line) { create :line }
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
        expect(page).to have_content(device.device_model_name)
      end
      it 'should show log entries' do
        expect(page).to have_css('.history')
      end
      it 'should have the option to edit a device' do
        expect(page).to have_content('Edit')
      end

      it 'has a link to swap lines if the device has a line' do
        expect(page).to have_content('Swap Line')
      end
      it 'does not have a link to swap lines if htere is not a line attached to the device' do
        device.line = nil
        device.save
        visit device_path device
        expect(page).not_to have_content('Swap Line')
      end
    end

    context 'for deployed devices' do
      let(:deployed_device) { create :device, device_states: [deployed] }
      let(:person) { create :person }
      let!(:deployed) { create :device_state, name: 'Deployed' }
      let!(:device_deployment) { create :device_deployment, device: deployed_device, person: person}

      before(:each) do
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
    end
  end
end