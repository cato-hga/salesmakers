require 'rails_helper'

describe 'Device Deployments NON-CRUD actions' do

  context 'for deployment' do
    let(:device) { create :device }
    let!(:deployed) { create :device_state, name: 'Deployed' }
    let(:person) { Person.first }
    let(:tracking_number) { '123456789' }
    let(:comment) { 'This is a foo comment' }

    it 'deploys a non-deployed device' do
      visit device_path device
      click_on 'Deploy'
      expect(page).to have_content(person.display_name)
      click_on 'Deploy'
      expect(page).to have_content('New Deployment Information')
      fill_in 'Tracking number', with: tracking_number
      fill_in 'Comment', with: comment
      click_on 'Deploy'
      device.reload
      expect(device.device_states).to include(deployed)
      expect(page).to have_content person.name
      expect(page).to have_content comment
      expect(page).not_to have_selector('a', text: 'Deploy')
    end
  end

  describe 'GET recoup' do
    let(:deployed_device) { create :device, person: person }
    let(:person) { create :person, personal_email: 'test@test.com' }
    let!(:deployed) { create :device_state, name: 'Deployed' }
    let(:device_deployment) { create :device_deployment, device: deployed_device, person: person }
    before(:each) do
      deployed_device.device_states << deployed
      deployed_device.device_deployments << device_deployment
      deployed_device.save
      visit device_path deployed_device
      click_link 'Recoup'
      fill_in 'Notes', with: 'Test recoup'
      click_on 'Recoup'
    end

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
