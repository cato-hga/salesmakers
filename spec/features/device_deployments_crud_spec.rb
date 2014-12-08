require 'rails_helper'

describe 'Device Deployments CRUD actions' do

  describe 'GET select_user' do
    let(:device) { create :device }
    before do
      visit device_path device
      click_link 'Deploy'
    end
    it 'should give a list of users' do
      expect(page).to have_content('System Administrator')
    end

    it 'should redirect to the "new" action when a Deploy button is clicked' do
      click_link 'Deploy'
      expect(page).to have_content("New Deployment Information")
    end
  end

  describe 'GET new' do
    let(:device) { create :device, person_id: person.id}
    let(:person) { Person.first }
    before do
      visit device_path device
      click_link 'Deploy'
      click_link 'Deploy'
    end
    it 'should prompt for tracking and comments' do
      expect(page).to have_content 'Tracking number'
      expect(page).to have_content 'Comment'
    end
    it 'should show a list of current devices assigned to a user' do
      expect(page).to have_content 'Current Devices Assigned'
    end
  end

  describe 'GET recoup' do
    let(:deployed_device) { create :device }
    let(:person) { create :person }
    let(:deployed) { DeviceState.find_by name: 'Deployed' }
    let(:device_deployment) { create :device_deployment, device: deployed_device, person: person }
    before(:each) do
      deployed_device.device_states << deployed
      deployed_device.device_deployments << device_deployment
      deployed_device.save
      visit device_path deployed_device
      click_link 'Recoup'
    end

    it 'should prompt for confirmation'
    it 'should NOT show the deployed status' do
      within('.device_states') do
        expect(page).not_to have_content('Deployed')
      end
    end

    it 'should create a log entry' do
      within('.history') do
        expect(page).to have_content('Recouped')
      end
    end
    it 'should set the end date for a deployment' do
      within('.deployments') do
        expect(page).to have_content(DateTime.now.strftime('%m/%d/%Y'))
      end
    end

    it 'should remove the device from the persons inventory' do
      within('.deployments') do
        expect(page).not_to have_content('to present')
      end
    end
  end
end
