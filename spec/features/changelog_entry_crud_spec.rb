require 'rails_helper'

describe 'ChangelogEntry CRUD actions' do
  let!(:person) { create :it_tech_person }
  let(:permission_manage) { create :permission, key: 'changelog_entry_manage' }

  before do
    Time.zone = ActiveSupport::TimeZone["Eastern Time (US & Canada)"]
    person.position.permissions << permission_manage
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'have the correct page headings' do
    specify 'for new' do
      visit new_changelog_entry_path
      expect(page).to have_selector('h1', text: 'New Changelog Entry')
    end

    specify 'for index' do
      visit changelog_entries_path
      expect(page).to have_selector('h1', text: 'Changelog Entries')
    end
  end

  context 'for creating' do
    let(:project) { create :project }
    let(:department) { Department.first }
    let(:released_string) { Time.zone.local(Date.current.year, Date.current.month, Date.current.day, 9, 0, 0) }

    let(:changelog_entry) { build :changelog_entry }

    it 'creates a new changelog entry with minimal values' do
      visit changelog_entries_path
      click_on 'new_action_button'
      fill_in 'Heading', with: changelog_entry.heading
      fill_in 'Description', with: changelog_entry.description
      fill_in 'Released', with: released_string
      click_on 'Save'
      visit changelog_entries_path
      expect(page).to have_content(changelog_entry.heading)
    end

    it 'displays validation errors' do
      visit new_changelog_entry_path
      click_on 'Save'
      expect(page).to have_content("can't be blank")
    end

    it 'creates a new changelog entry with a department' do
      visit new_changelog_entry_path
      fill_in 'Heading', with: changelog_entry.heading
      fill_in 'Description', with: changelog_entry.description
      fill_in 'Released', with: released_string
      select department.name, from: 'Department'
      click_on 'Save'
      expect(ChangelogEntry.first.department_id).to eq(department.id)
    end

    it 'creates a new changelog entry with a project' do
      project
      visit new_changelog_entry_path
      fill_in 'Heading', with: changelog_entry.heading
      fill_in 'Description', with: changelog_entry.description
      fill_in 'Released', with: released_string
      select project.name, from: 'Project'
      click_on 'Save'
      expect(ChangelogEntry.first.project_id).to eq(project.id)
    end

    it 'creates a new changelog entry with all_hq' do
      visit new_changelog_entry_path
      fill_in 'Heading', with: changelog_entry.heading
      fill_in 'Description', with: changelog_entry.description
      fill_in 'Released', with: released_string
      check 'All HQ?'
      click_on 'Save'
      expect(ChangelogEntry.first).to be_all_hq
    end

    it 'creates a new changelog entry with all_field' do
      visit new_changelog_entry_path
      fill_in 'Heading', with: changelog_entry.heading
      fill_in 'Description', with: changelog_entry.description
      fill_in 'Released', with: released_string
      check 'All field?'
      click_on 'Save'
      expect(ChangelogEntry.first).to be_all_field
    end

    it 'sets the correct time' do
      visit new_changelog_entry_path
      fill_in 'Heading', with: changelog_entry.heading
      fill_in 'Description', with: changelog_entry.description
      fill_in 'Released', with: released_string
      check 'All field?'
      click_on 'Save'
      change = ChangelogEntry.first
      change.reload
      expect(change.released).to be_within(1.second).of(released_string)
    end
  end

end