require 'rails_helper'

describe 'DirecTVCustomer notes' do
  let(:person) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_update, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_update) { Permission.new key: 'directv_customer_update',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'directv_customer_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:directv_customer) { create :directv_customer }

  let(:note) { 'This here is a note, folks!' }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'context for adding notes' do
    before do
      visit directv_customer_path(directv_customer)
      within '#new_directv_customer_note' do
        fill_in 'directv_customer_note_note', with: note
        click_on 'Save'
      end
    end

    it 'saves the note' do
      within '#directv_customer_notes' do
        expect(page).to have_content(note)
      end
    end
  end
end