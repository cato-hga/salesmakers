require 'rails_helper'

describe 'ComcastCustomer notes' do
  let(:person) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_update, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_update) { Permission.new key: 'comcast_customer_update',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'comcast_customer_index',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let!(:comcast_customer) { create :comcast_customer }

  let(:note) { 'This here is a note, folks!' }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'context for adding notes' do
    before do
      visit comcast_customer_path(comcast_customer)
      within '#new_comcast_customer_note' do
        fill_in 'comcast_customer_note_note', with: note
        click_on 'Save'
      end
    end

    it 'saves the note' do
      within '#comcast_customer_notes' do
        expect(page).to have_content(note)
      end
    end
  end
end