require 'rails_helper'

describe 'communication logging' do
  let!(:person) { create :it_tech_person }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
  end

  it 'shows an SMS message', :vcr do
    sms_message = create :sms_message, to_person: person
    visit about_person_path(person)
    within '#communication_log' do
      expect(page).to have_content(sms_message.message)
    end
  end

  it 'shows an email message' do
    email_message = create :email_message, to_person: person
    visit about_person_path(email_message.to_person)
    within '#communication_log' do
      expect(page).to have_content(email_message.subject)
    end
  end
end