require 'rails_helper'

describe 'actions on Lines' do
  let!(:it_tech) { create :it_tech_person }
  let(:permission_index) { create :permission, key: 'line_index' }
  let(:permission_new) { create :permission, key: 'line_new' }
  let(:permission_update) { create :permission, key: 'line_update' }
  let(:permission_edit) { create :permission, key: 'line_edit' }
  let(:permission_destroy) { create :permission, key: 'line_destroy' }
  let(:permission_create) { create :permission, key: 'line_create' }
  let(:permission_show) { create :permission, key: 'line_show' }
  let(:permission_state_index) { create :permission, key: 'line_state_index' }
  let(:permission_state_new) { create :permission, key: 'line_state_new' }
  let(:permission_state_update) { create :permission, key: 'line_state_update' }
  let(:permission_state_edit) { create :permission, key: 'line_state_edit' }
  let(:permission_state_destroy) { create :permission, key: 'line_state_destroy' }
  let(:permission_state_create) { create :permission, key: 'line_state_create' }
  let(:permission_state_show) { create :permission, key: 'line_state_show' }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
  end

  it 'should show the search bar' do
    line = create :line
    visit line_path(line)
    expect(page).to have_selector('#q_unstripped_identifier_cont')
  end

  context 'for line states' do
    before(:each) do
      it_tech.position.permissions << permission_state_update
      it_tech.position.permissions << permission_update
      it_tech.position.permissions << permission_index
    end
    let(:line) { create :line }
    let!(:locked_line_state) {
      create :line_state,
             name: 'Locked',
             locked: true
    }
    let!(:unlocked_line_state) {
      create :line_state,
             name: 'Unlocked',
             locked: false
    }

    it 'allows an unlocked line state to be removed' do
      line.line_states << unlocked_line_state
      visit line_path(line)
      find('.line_state a.remove').click
      expect(page).not_to have_selector('.line_state', text: unlocked_line_state.name)
    end

    it 'does not allow a locked line state to be removed' do
      line.line_states << locked_line_state
      visit line_path(line)
      expect(page).not_to have_selector('.line_state a.remove')
    end

    it 'adds an unlocked line state' do
      visit line_path(line)
      within '.line_states' do
        select unlocked_line_state.name, from: 'add_line_state_select'
        click_on '+'
      end
      expect(page).to have_selector('.line_state', text: unlocked_line_state.name)
    end

    it 'does not allow a locked line state to be added' do
      visit line_path(line)
      within '.line_states' do
        expect(page).not_to have_selector('option', text: locked_line_state.name)
      end
    end
  end

  context 'for deactivation', js: true do
    let(:active_state) { create :line_state, name: 'Active', locked: true }
    let(:line) {
      new_line = create :line
      new_line.line_states << active_state
      new_line
    }
    let!(:device) { create :device, line: line }

    subject {
      visit line_path(line)
      page.driver.browser.accept_js_confirms
      within '#main_container header' do
        click_on 'Deactivate'
      end
    }

    it 'deactivates a line' do
      subject
      visit lines_path
      expect(page).not_to have_selector('a', text: 'Active')
    end

    it 'detaches a line from a device' do
      subject
      visit device_path(device)
      expect(page).not_to have_content(line.identifier)
    end

    context 'from device#show' do
      let(:device_index) { create :permission, key: 'device_index' }
      let(:device_update) { create :permission, key: 'device_update' }
      before(:each) do
        it_tech.position.permissions << permission_update
      end
      it 'deactivates and detaches the line' do
        visit device_path(device)
        page.driver.browser.accept_js_confirms
        within 'p#line' do
          click_on 'Deactivate'
        end
        visit device_path(device)
        within 'p#line' do
          expect(page).not_to have_content('Active')
        end
      end
    end
  end
end