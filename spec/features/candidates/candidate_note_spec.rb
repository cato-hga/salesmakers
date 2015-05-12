require 'rails_helper'

describe 'Candidate notes' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_index, permission_show] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_show) { Permission.new key: 'candidate_show',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let!(:candidate) { create :candidate }

  let(:note) { 'This here is a note, folks!' }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
  end

  describe 'context for adding notes' do
    before do
      visit candidate_path(candidate)
      within '#new_candidate_note' do
        fill_in 'candidate_note_note', with: note
        click_on 'Save'
      end
    end

    it 'saves the note' do
      within '#candidate_notes' do
        expect(page).to have_content(note)
      end
    end
  end
end