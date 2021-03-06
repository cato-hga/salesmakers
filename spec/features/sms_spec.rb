require 'rails_helper'

describe 'SMS messaging' do
  let!(:person) { create :it_tech_person, position: position }
  let!(:candidate) { create :candidate, mobile_phone: '7274985180' }
  let(:position) { create :it_tech_position, department: department, permissions: [candidate_index] }
  let(:department) { create :information_technology_department }
  let(:candidate_index) { create :permission, key: 'candidate_index' }
  let(:rep) { create :person }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'links on view' do
    it 'shows for People#index and People#search' do
      visit people_path
      expect(page).to have_selector('a.send_contact')
    end

    it 'shows for People#org_chart' do
      visit org_chart_people_path
      expect(page).to have_selector('a.send_contact')
    end

    it 'shows for People#show' do
      visit person_path(rep)
      expect(page).to have_selector('a.send_contact')
    end

    it 'shows for Candidate#index' do
      visit candidates_path
      expect(page).to have_selector('a.send_contact')
    end

    context 'for DevicesController' do
      let(:device) { create :device, person: person }
      let!(:device_deployment) { create :device_deployment, device: device, person: person }
      let(:permission_index) { create :permission, key: 'device_index' }

      it 'shows for Devices#index' do
        person.position.permissions << permission_index
        visit devices_path
        expect(page).to have_selector('a.send_contact')
      end

      it 'shows for Device#show' do
        visit device_path(device_deployment.device)
        expect(page).to have_selector('a.send_contact')
      end
    end
  end

  context 'sending a message (not a candidate)' do
    let(:message) { 'This is an example message.' }

    it 'sends an SMS message', :vcr do
      visit people_path
      within all('tr').last do
        find('a.send_contact').click
      end
      fill_in 'contact_message', with: message
      click_on 'Send'
      visit person_path(person)
      expect(page).to have_content(message)
      within '#communication_log' do
        expect(page).to have_content(message)
      end
    end
  end

  describe 'message counter', js: true do
    before { visit new_sms_message_person_path(person) }

    it 'shows the proper message count' do
      fill_in 'contact_message', with: 'a'*160
      expect(page).to have_selector('.within_length.ok', text: '0')
    end

    it 'shows a red message count when over 160 characters' do
      fill_in 'contact_message', with: 'a'*161
      expect(page).to have_selector('.within_length.bad', text: '-1')
    end
  end

end