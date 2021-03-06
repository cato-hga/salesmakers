require 'rails_helper'

describe 'DeviceStates CRUD actions' do

  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  let(:permission_index) { create :permission, key: 'device_state_index' }
  let(:permission_new) { create :permission, key: 'device_state_new' }
  let(:permission_update) { create :permission, key: 'device_state_update' }
  let(:permission_edit) { create :permission, key: 'device_state_edit' }
  let(:permission_destroy) { create :permission, key: 'device_state_destroy' }
  let(:permission_create) { create :permission, key: 'device_state_create' }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for creating' do
    let(:device_state) { build :device_state }
    before(:each) do
      person.position.permissions << permission_index
      person.position.permissions << permission_create
      visit device_states_path
      within '#main_container h1' do
        click_on 'new_action_button'
      end
    end
    subject {
      fill_in 'Name', with: device_state.name
      click_on 'Save'
    }

    it 'has the correct page title' do
      expect(page).to have_selector('h1', text: 'New Device State')
    end

    it 'creates a new device state' do
      subject
      expect(page).to have_content(device_state.name)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end

  context 'for reading' do
    let!(:device_state) { create :device_state }
    let(:permission_device_index) { create :permission, key: 'device_index' }

    it 'navigates to the device states index' do
      person.position.permissions << permission_index
      person.position.permissions << permission_device_index
      visit devices_path
      within '#main_container header h1' do
        click_on 'Edit States'
      end
      expect(page).to have_content(device_state.name)
    end
  end

  context 'for updating' do
    context 'unlocked device states' do
      let!(:device_state) { create :device_state }
      let(:new_name) { 'New Name' }

      subject {
        person.position.permissions << permission_index
        person.position.permissions << permission_new
        person.position.permissions << permission_update
        visit device_states_path
        click_on device_state.name
        fill_in 'Name', with: new_name
        click_on 'Save'
      }

      it 'edits an unlocked device state' do
        subject
        expect(page).to have_content(new_name)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

    end

    context 'locked device states' do
      let!(:device_state) { create :device_state, locked: true }

      it 'shows no link for a locked device state' do
        visit device_states_path
        expect(page).not_to have_selector('a', text: device_state.name)
      end
    end
  end

  context 'for destroying' do
    let!(:device_state) { create :device_state }
    let(:device) { create :device }

    subject do
      person.position.permissions << permission_index
      person.position.permissions << permission_destroy
      person.position.permissions << permission_update
      visit device_states_path
      click_on device_state.name
      within '#main_container header' do
        click_on 'delete_action_button'
      end
    end

    it 'destroys a device state' do
      subject
      visit device_states_path
      expect(page).not_to have_content(device_state.name)
    end

    it 'destroys each association of a device with a destroyed device state' do
      device.device_states << device_state
      subject
      visit devices_path
      expect(page).not_to have_content(device_state.name)
    end
  end
end