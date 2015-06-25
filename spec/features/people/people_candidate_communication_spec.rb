require 'rails_helper'

describe 'communication with candidates and people showing on both show pages' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  let(:candidate) { create :candidate, person: person }
  let(:person) { create :person }

  describe 'showing candidate contact entries on the People#show' do
    let!(:contact) { create :candidate_contact, candidate: candidate }

    before do
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
      visit person_path(person)
    end

    it 'shows the communication log entry' do
      expect(page).to have_content(contact.notes)
    end
  end

  describe 'showing person communication log entries on the Candidates#show' do
    let!(:entry) { create :communication_log_entry, person: person, loggable: create(:sms_message) }
    let!(:permission) { create :permission, key: 'candidate_index' }

    before do
      position.permissions << permission
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
      visit candidate_path(candidate)
    end

    it 'shows the communication log entry' do
      expect(page).to have_content(entry.loggable.message)
    end
  end
end
