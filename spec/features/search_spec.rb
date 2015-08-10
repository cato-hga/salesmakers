require 'rails_helper'

describe 'searching' do
  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
  end
  context 'on Lines#index' do
    let(:permission_index) { create :permission, key: 'line_index' }
    let!(:line) { create :line }

    it 'strips non-numeric characters from the identifier query' do
      person.position.permissions << permission_index
      visit lines_path
      fill_in 'q_unstripped_identifier_cont', with: line.identifier[0..2] + '-' + line.identifier[3..5]
      click_on 'search'

      display = '(' + line.identifier[0..2] + ') '
      display += line.identifier[3..5] + '-' + line.identifier[6..9]

      expect(page).to have_selector('a', text: display)
    end
  end

  context 'on Devices#index' do
    let(:permission_index) { create :permission, key: 'device_index' }
    let!(:device) { create :device, line: create(:line) }

    before {
      person.position.permissions << permission_index
      visit devices_path
    }

    it 'strips non-numeric characters from the line identifier query' do
      identifier = device.line.identifier
      fill_in 'q_line_unstripped_identifier_cont', with: identifier[0..2] + '-' + identifier[3..5]
      click_on 'search'

      display = '(' + identifier[0..2] + ') '
      display += identifier[3..5] + '-' + identifier[6..9]

      expect(page).to have_selector('a', text: display)
    end

    it 'strips non-alphanumeric characters from the serial query' do
      serial = device.serial
      fill_in 'q_unstripped_serial_cont', with: serial[0..2] + '-' + serial[3..6]
      click_on 'search'
      expect(page).to have_selector('a', text: serial)
    end

    it 'strips non-alphanumeric characters from the identifier query' do
      identifier = device.identifier
      fill_in 'q_unstripped_identifier_cont', with: identifier[0..2] + '-' + identifier[3..6]
      click_on 'search'
      expect(page).to have_selector('a', text: identifier)
    end
  end

  context 'on ComcastLeads#index' do
    let(:permission_index) { create :permission, key: 'comcast_lead_index' }
    let(:comcast_customer) { create :comcast_customer, person: person }
    let!(:comcast_lead) { create :comcast_lead, comcast_customer: comcast_customer, follow_up_by: Date.tomorrow }

    before do
      person.position.permissions << permission_index
      visit comcast_leads_path
    end

    it 'searches for a rep' do
      fill_in 'q_comcast_customer_person_display_name_cont', with: person.display_name[6]
      click_on 'search'
      expect(page).to have_content(comcast_customer.name)
    end

    it 'searches for a customer first name' do
      fill_in 'q_comcast_customer_first_name_cont', with: comcast_customer.first_name[3]
      expect(page).to have_content(comcast_customer.name)
    end

    it 'searches for a customer last name' do
      fill_in 'q_comcast_customer_last_name_cont', with: comcast_customer.last_name[3]
      expect(page).to have_content(comcast_customer.name)
    end

    it 'searches for follow up by after date' do
      fill_in 'q_follow_up_by_gteq', with: Date.today.strftime('%m/%d/%Y')
      expect(page).to have_content(comcast_customer.name)
    end

    it 'searches for follow up by before date' do
      fill_in 'q_follow_up_by_lteq', with: (Date.today + 2.days).strftime('%m/%d/%Y')
      expect(page).to have_content(comcast_customer.name)
    end

    it 'searches for a follow up by date range' do
      fill_in 'q_follow_up_by_gteq', with: Date.today.strftime('%m/%d/%Y')
      fill_in 'q_follow_up_by_lteq', with: (Date.today + 2.days).strftime('%m/%d/%Y')
      expect(page).to have_content(comcast_customer.name)
    end
  end
end