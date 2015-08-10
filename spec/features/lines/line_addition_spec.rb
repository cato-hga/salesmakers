require 'rails_helper'

describe 'Line Addition' do
  let(:it_tech) { create :it_tech_person, position: position }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'line_index', permission_group: permission_group, description: description }
  let(:permission_new) { Permission.new key: 'line_new', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'line_update', permission_group: permission_group, description: description }
  let(:permission_edit) { Permission.new key: 'line_edit', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'line_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'line_create', permission_group: permission_group, description: description }
  let(:permission_show) { Permission.new key: 'line_show', permission_group: permission_group, description: description }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  context 'for single lines' do
    context 'success' do
      let(:position) { create :it_tech_position, permissions: [permission_index, permission_create] }
      let!(:service_provider) { create :technology_service_provider }
      let!(:creator) { Person.first }
      let(:contract_end_date) { Date.today + 1.year }
      let!(:line_state) { create :line_state, name: 'Active' }
      before(:example) do
        visit new_line_path
        fill_in :line_contract_end_date, with: contract_end_date.strftime('%m/%d/%Y')
        select service_provider.name, from: 'line_technology_service_provider_id'
        fill_in :line_identifier, with: '5555555555'
      end
      subject {
        click_on 'Receive'
      }
      it 'creates a line' do
        expect { subject }.to change(Line, :count).by(1)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'assigns the correct contract end date' do
        subject
        new_line = Line.first
        expect(new_line.contract_end_date).to eq(contract_end_date)
      end
      it 'assigns the "active" status to the new line' do
        subject
        new_line = Line.first
        expect(new_line.line_states).to include(line_state)
      end
      it 'assigns the correct provider' do
        subject
        new_line = Line.first
        expect(new_line.technology_service_provider).to eq(service_provider)
      end
      it 'redirects to lines#index' do
        subject
        expect(page).to have_content(contract_end_date.strftime('%m/%d/%Y'))
      end
    end
  end

  context 'for multiple lines' do
    describe 'row addition', js: true do
      let(:position) { create :it_tech_position, permissions: [permission_create] }
      before {
        visit new_line_path
        click_on 'Add'
      }

      it 'should add additional lines' do
        expect(page).to have_css('div .line_field', count: 2)
      end

      it 'should change the Add button to Delete for all but the last row' do
        within('#lines .row:first-of-type') do
          expect(page).to have_selector('.delete_row')
        end
        within('#lines .row:last-of-type') do
          expect(page).to have_selector('.add_row')
        end
      end
    end
  end
end