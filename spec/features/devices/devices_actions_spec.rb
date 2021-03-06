require 'rails_helper'

describe 'Devices NON-CRUD actions' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_update, permission_index] }
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

  it 'should show the search bar' do
    device = create :device
    visit device_path(device)
    expect(page).to have_selector('#q_unstripped_serial_cont')
  end

  describe 'write_off' do
    let(:device) { create :device }
    let!(:device_state) { create :device_state, name: 'Written Off' }

    before(:each) do
      visit device_path device
    end

    it 'should add the "Write Off" device state' do
      click_link 'Write Off'
      within('.device_states') do
        expect(page).to have_content('Written Off')
      end
    end
    it 'should add a "written off" record in the device history' do
      click_link 'Write Off'
      within('.history') do
        expect(page).to have_content('Written Off')
      end
    end
    it 'should no longer display the Write Off button' do
      click_link 'Write Off'
      within('header h1') do
        expect(page).not_to have_link('Write Off')
      end
    end

    it 'should no longer display the Recoup button' do
      click_link 'Write Off'
      within('header h1') do
        expect(page).not_to have_link('Recoup')
      end
    end

    context 'for a deployed device' do
      let(:person) { create :person }
      let(:deployment) { create :device_deployment, device: device, person: person }
      it 'should indicate that the device is written off under deployments' do
        device.device_deployments << deployment
        click_link 'Write Off'
        within('.deployments') do
          expect(page).to have_content('WRITTEN OFF')
        end
      end
    end
  end

  describe 'lost/stolen' do
    let(:device) { create :device }
    let!(:lost_stolen) { create :device_state, name: 'Lost or Stolen', locked: true }

    context 'when reporting lost or stolen' do
      before {
        visit device_path(device)
      }

      subject {
        within '#main_container header' do
          click_on 'Lost/Stolen'
        end
      }

      it 'does not show the "Found" button when not Lost/Stolen' do
        expect(page).not_to have_selector('.button[value="Found"]')
      end

      it 'does not show the deploy button when lost or stolen' do
        subject
        expect(page).not_to have_selector('.button[value="Deploy"]')
      end

      it 'reports it lost or stolen' do
        subject
        expect(page).to have_selector('.device_state', text: 'Lost or Stolen')
      end

      context 'for a deployed device' do
        let(:person) { create :person }
        let(:deployment) { create :device_deployment, device: device, person: person }
        it 'does not show the recoup button when lost or stolen' do
          device.device_deployments << deployment
          visit device_path(device)
          within '#main_container header' do
            click_on 'Lost/Stolen'
          end
          expect(page).not_to have_selector('.button[value="Recoup"]')
        end
      end
    end
  end

  describe 'when reporting found' do
    let(:device) { create :device, device_states: [lost_stolen, written_off] }
    let!(:lost_stolen) { create :device_state, name: 'Lost or Stolen', locked: true }
    let!(:written_off) { create :device_state, name: 'Written Off', locked: true }
    before do
      visit device_path(device)
    end

    subject {
      within '#main_container header' do
        click_on 'Found'
      end
    }

    it 'does not show the "Lost/Stolen" button when Lost/Stolen' do
      expect(page).not_to have_selector('.button[value="Lost/Stolen"]')
    end

    it 'reports as found', js: true do
      subject
      expect(page).not_to have_selector('.device_state', text: 'Lost or Stolen')
      expect(page).not_to have_selector('.device_state', text: 'Written Off')
    end

    context 'with only lost_stolen state' do
      let(:device) { create :device, device_states: [lost_stolen] }
      let!(:lost_stolen) { create :device_state, name: 'Lost or Stolen', locked: true }
      before do
        visit device_path(device)
      end
      subject {
        within '#main_container header' do
          click_on 'Found'
        end
      }
      it 'reports as found' do
        subject
        expect(page).not_to have_selector('.device_state', text: 'Lost or Stolen')
      end
    end

    context 'with only written_off state' do
      let(:device) { create :device, device_states: [written_off] }
      let!(:written_off) { create :device_state, name: 'Written Off', locked: true }
      before do
        visit device_path(device)
      end
      subject {
        within '#main_container header' do
          click_on 'Found'
        end
      }
      it 'reports as found' do
        subject
        expect(page).not_to have_selector('.device_state', text: 'Written Off')
      end
    end
  end

  describe 'recoup' do
    let(:deployed_device) { create :device, person: person }
    let(:person) { create :person }
    let!(:deployed) { create :device_state, name: 'Deployed' }
    let!(:device_deployment) { create :device_deployment, device: deployed_device, person: person }
    let(:notes) { 'Good condition $0' }

    before(:each) do
      deployed_device.device_states << deployed
      visit device_path deployed_device
      click_link 'Recoup'
      fill_in 'Notes', with: notes
      click_on 'Recoup'
    end

    it 'should remove device states ' do
      within('.device_states') do
        expect(page).not_to have_content('Written Off')
        expect(page).not_to have_content('Exchanging')
        expect(page).not_to have_content('Lost or Stolen')
        expect(page).not_to have_content('Deployed')
      end
    end

    it 'should add a "Recouped" record in the device history' do
      within('.history') do
        expect(page).to have_content('Recouped')
      end
    end

    it 'should no longer display the Recoup button' do
      within('header h1') do
        expect(page).not_to have_link('Recoup')
      end
    end

    it 'should show the Deploy button' do
      within('header h1') do
        expect(page).to have_link('Deploy')
      end
    end

    it 'should save the recoup notes' do
      expect(page).to have_content(notes)
    end
  end

  context 'for device states' do
    let(:device) { create :device }
    let!(:locked_device_state) {
      create :device_state,
             name: 'Locked',
             locked: true
    }
    let!(:unlocked_device_state) {
      create :device_state,
             name: 'Unlocked',
             locked: false
    }

    before(:each) do
      it_tech.position.permissions << permission_update
    end
    it 'allows an unlocked device state to be removed' do
      device.device_states << unlocked_device_state
      visit device_path(device)
      find('.device_state .remove').click
      expect(page).not_to have_selector('.device_state', text: unlocked_device_state.name)
    end

    it 'does not allow a locked device state to be removed' do
      device.device_states << locked_device_state
      visit device_path(device)
      expect(page).not_to have_selector('.device_state .remove')
    end

    it 'adds an unlocked device state' do
      visit device_path(device)
      within '.edit_device_states' do
        select unlocked_device_state.name, from: 'add_device_state_select'
        click_on '+'
      end
      expect(page).to have_selector('.device_state', text: unlocked_device_state.name)
    end

    it 'does not allow a locked device state to be added' do
      visit device_path(device)
      within '.device_states' do
        expect(page).not_to have_selector('option', text: locked_device_state.name)
      end
    end
  end

  context 'for searching' do
    let(:line) { create :line, identifier: '4444444444' }
    let!(:device) { create :device, serial: '998899889988', identifier: '998899889988', line: line }
    let(:tracking_number) { '885522225588' }
    let!(:device_deployment) { create :device_deployment, tracking_number: tracking_number }

    it 'searches for tracking numbers' do
      visit devices_path
      fill_in 'q_device_deployments_tracking_number_cont', with: tracking_number[0..7]
      click_on 'search'
      expect(page).to have_content(device_deployment.device.serial)
      expect(page).not_to have_content(device.serial)
    end
  end

  describe 'edit' do
    let!(:device) { create :device }
    before {
      visit device_path device
      click_on 'Edit'
    }

    it 'has the correct device' do
      expect(page).to have_content(device.serial)
    end

    it 'redirects to device#show upon successful edit' do
      fill_in 'serial', with: '123456'
      click_on 'Finish'
      expect(page).to have_content '123456'
      expect(page).to have_content 'Device Updated!' #Double check that it redirects
    end

    it 'creates log entries' do
      fill_in 'serial', with: '123456'
      click_on 'Finish'
      within('.history') do
        expect(page).to have_content 'Updated'
      end
    end
  end

  describe 'repair' do
    let(:device) { create :device }
    let!(:repair) { create :device_state, name: 'Repairing', locked: true }
    before {
      visit device_path(device)
    }
    subject {
      within '#main_container header' do
        click_on 'Repair'
      end
    }


    it 'does not show the repair button when in repair' do
      subject
      expect(page).not_to have_selector('.button[value="Repair"]', exact: true)
    end

    it 'reports it as in repair' do
      subject
      expect(page).to have_selector('.device_state', text: 'Repairing')
    end
  end

  describe 'fixed' do
    let(:device) { create :device, device_states: [repair] }
    let(:repair) { create :device_state, name: 'Repairing', locked: true }

    before {
      visit device_path(device)
      click_on 'Repaired'
    }

    it 'swaps buttons' do
      expect(page).not_to have_selector('.button[value="Repaired"]')
      expect(page).to have_selector('.button[value="Repair"]', exact: true)
    end

    it 'clears the repair device state' do
      expect(page).not_to have_selector('.device_state', text: 'Repairing')
    end

    it 'creates a log entry' do
      within('.history') do
        expect(page).to have_content('repaired')
      end
    end
  end

end