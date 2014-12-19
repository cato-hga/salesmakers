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

  context 'for device states' do
    let(:device) { create :device }
    let(:locked_device_state) {
      create :device_state,
             name: 'Locked',
             locked: true
    }
    let(:unlocked_device_state) {
      create :device_state,
             name: 'Unlocked',
             locked: false
    }

    it 'allows an unlocked device state to be removed' do
      device.device_states << unlocked_device_state
      visit device_path(device)
      find('.device_state a.remove').click
      expect(page).not_to have_content(unlocked_device_state.name)
    end

    it 'does not allow a locked device state to be removed' do
      device.device_states << locked_device_state
      visit device_path(device)
      expect(page).not_to have_selector('.device_state a.remove')
    end
  end
end