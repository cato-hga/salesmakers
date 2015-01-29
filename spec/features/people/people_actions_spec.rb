require 'rails_helper'

describe 'actions involving People' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'when viewing' do
    let!(:log_entry) { create :log_entry, trackable: person }
    let(:person) { create :person }
    let!(:person_address) { create :person_address, person: person }

    before do
      person.position.update hq: true
    end

    it 'should show log entries on the show page', :vcr do
      visit person_path(person)
      expect(page).to have_content("Created person #{person.display_name}")
    end

    it "should show the person's address", :vcr do
      visit person_path(person)
      expect(page).to have_content(person_address.line_1)
      expect(page).to have_content(person_address.city)
      expect(page).to have_content(person_address.state)
      expect(page).to have_content(person_address.zip)
    end
  end

end