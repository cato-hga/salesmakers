require 'rails_helper'

describe 'log_entries index' do
  let!(:log_entry) { create :log_entry, person: it_tech }
  let(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'log_entry_index', permission_group: permission_group, description: description }
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    visit log_entries_path
  end

  it 'searches for performed by' do
    fill_in 'q_person_display_name_cont', with: person.first_name[0]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(person.name)
  end

  it 'searches for types' do
    fill_in 'q_trackable_type_cont', with: log_entry.trackable_type[0]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(log_entry.trackable_type)
  end

  it 'searches for dates' do
    fill_in 'q_created_at_date_equals', with: log_entry.created_at
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(log_entry.created_at.strftime('%l:%M%P %Z'))
  end

end