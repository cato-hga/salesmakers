require 'rails_helper'

describe 'ReportQuery creation' do
  let(:report_query) { build :report_query }
  let!(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [report_query_create] }
  let(:report_query_create) { create :permission, key: 'report_query_create' }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit new_report_query_path
    fill_in 'Report name', with: report_query.name
    fill_in 'Category', with: report_query.category_name
    fill_in 'Database name', with: report_query.database_name
    fill_in 'Query', with: report_query.query
    fill_in 'Permission key', with: report_query.permission_key
  end

  it 'creates a report query' do
    expect {
      click_on 'Save'
    }.to change(ReportQuery, :count).by 1
  end

  it 'creates a log entry' do
    expect {
      click_on 'Save'
    }.to change(LogEntry, :count).by 1
  end

  it 'creates a permission group' do
    expect {
      click_on 'Save'
    }.to change(PermissionGroup, :count).by 1
  end

  it 'creates a permission' do
    expect {
      click_on 'Save'
    }.to change(Permission, :count).by 1
  end
end