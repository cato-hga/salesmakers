require 'rails_helper'

describe 'Device notes' do
  let(:it_tech) { create :it_tech_person }
  let!(:device) { create :device }

  let(:note) { 'This is a note!' }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  describe 'context for adding notes' do
    before do
      visit device_path(device)
      within '#new_device_note' do
        fill_in 'device_note_note', with: note
        click_on 'Save'
      end
    end

    it 'saves the note' do
      within '#device_notes' do
        expect(page).to have_content(note)
      end
    end
  end
end
