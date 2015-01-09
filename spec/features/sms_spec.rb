require 'rails_helper'

describe 'SMS messaging' do

  describe 'links on view' do
    let(:person) { Person.first }

    it 'shows for People#index and People#search' do
      visit people_path
      expect(page).to have_selector('a.send_contact')
    end

    it 'shows for People#org_chart' do
      visit org_chart_people_path
      expect(page).to have_selector('a.send_contact')
    end

    it 'shows for Poeple#about' do
      visit about_person_path(person)
      expect(page).to have_selector('a.send_contact')
    end

    context 'for DevicesController' do
      let(:device) { create :device, person: person }
      let!(:device_deployment) { create :device_deployment, device: device }

      it 'shows for Devices#index' do
        visit devices_path
        expect(page).to have_selector('a.send_contact')
      end

      it 'shows for Device#show' do
        visit device_path(device_deployment.device)
        expect(page).to have_selector('a.send_contact')
      end
    end
  end

  context 'sending a message' do
    let(:person) { Person.first }
    let(:message) { 'This is an example message.' }

    it 'sends an SMS message', :vcr do
      visit people_path
      find('a.send_contact').click
      fill_in 'contact_message', with: message
      click_on 'Send'
      visit about_person_path(person)
      expect(page).to have_content(message)
    end
  end

  describe 'message counter', js: true do
    let(:person) { Person.first }
    before { visit new_sms_message_person_path(person) }

    it 'shows the proper message count' do
      fill_in 'contact_message', with: 'a'*160
      expect(page).to have_selector('.sms_length.ok', text: '0')
    end

    it 'shows a red message count when over 160 characters' do
      fill_in 'contact_message', with: 'a'*161
      expect(page).to have_selector('.sms_length.bad', text: '-1')
    end
  end
end