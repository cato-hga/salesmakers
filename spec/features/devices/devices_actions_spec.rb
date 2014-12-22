require 'rails_helper'

describe 'Devices NON-CRUD actions' do

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
      before { visit device_path(device) }

      subject {
        page.driver.browser.accept_js_confirms
        within '#main_container header' do
          click_on 'Lost/Stolen'
        end
      }

      it 'does not show the "Found" button when not Lost/Stolen' do
        expect(page).not_to have_selector('.button', text: 'Found')
      end

      it 'reports it lost or stolen', js: true do
        subject
        expect(page).to have_selector('.device_state', text: 'Lost or Stolen')
      end
    end

    context 'when reporting found' do
      before do
        device.device_states << lost_stolen
        visit device_path(device)
      end

      subject {
        page.driver.browser.accept_js_confirms
        within '#main_container header' do
          click_on 'Found'
        end
      }

      it 'does not show the "Lost/Stolen" button when Lost/Stolen' do
        expect(page).not_to have_selector('.button', text: 'Lost/Stolen')
      end

      it 'reports as found', js: true do
        subject
        expect(page).not_to have_selector('.device_state', text: 'Lost or Stolen')
      end
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

    it 'allows an unlocked device state to be removed' do
      device.device_states << unlocked_device_state
      visit device_path(device)
      find('.device_state a.remove').click
      expect(page).not_to have_selector('.device_state', text: unlocked_device_state.name)
    end

    it 'does not allow a locked device state to be removed' do
      device.device_states << locked_device_state
      visit device_path(device)
      expect(page).not_to have_selector('.device_state a.remove')
    end

    it 'adds an unlocked device state' do
      visit device_path(device)
      within '.device_states' do
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
end