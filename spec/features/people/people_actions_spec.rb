require 'rails_helper'

describe 'actions involving People' do

  context 'when viewing' do
    let!(:log_entry) { create :log_entry, trackable: person }
    let(:person) { create :person }

    it 'should show log entries on the show page', :vcr do
      visit about_person_path(person)
      expect(page).to have_content("Created person #{person.display_name}")
    end
  end

end