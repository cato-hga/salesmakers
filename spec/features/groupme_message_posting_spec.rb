require 'rails_helper'

describe 'GroupMe message posting via bots' do
  let(:permission_group) { PermissionGroup.create name: 'Group' }
  let(:permission) {
    Permission.create key: 'group_me_group_post',
                      description: 'post messages to GroupMe groups via bot',
                      permission_group: permission_group
  }
  let(:position) { create :position }
  let(:person) { create :person, position: position }
  let(:area) { create :area }
  let!(:person_area) {
    PersonArea.create person: person,
                      area: area,
                      manages: true
  }
  let!(:group_me_group) {
    create :group_me_group,
           group_num: '8936279',
           area: area
  }
  let!(:second_group_me_group) {
    create :group_me_group,
           group_num: '12548729',
           area: area
  }

  before do
    person.position.permissions << permission
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GroupMeGroup index for a person' do
    before { visit new_post_group_me_groups_path }

    it 'should have the proper title' do
      expect(page).to have_selector('h1', 'Post to GroupMe Group(s)')
    end

    it 'should display GroupMe groups' do
      expect(page).to have_content(group_me_group.name)
    end

    it 'should display the project the GroupMe group belongs to' do
      expect(page).to have_content(area.project.name)
    end

    it 'posts a message', js: true do
      find('.select_all:first-of-type').click
      fill_in 'Message', with: 'This is a test GroupMe message from a bot.'
      click_on 'Post'
      expect(page).to have_content('successfully')
    end
  end

end