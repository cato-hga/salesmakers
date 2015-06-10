require 'rails_helper'

describe 'editing ReportQueries' do
  let!(:report_query) { create :report_query }
  let!(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [report_query_update] }
  let(:report_query_update) { create :permission, key: 'report_query_update' }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit edit_report_query_path(report_query)
    fill_in 'Report name', with: 'Bat Query'
    fill_in 'Category', with: 'Bat Category'
    fill_in 'Database name', with: 'bat_base'
    fill_in 'Query', with: 'SELECT bat FROM foo_bars'
  end

  it 'updates all fields on a query' do
    click_on 'Save'
    report_query.reload
    expect(report_query.name).to eq('Bat Query')
    expect(report_query.category_name).to eq('Bat Category')
    expect(report_query.database_name).to eq('bat_base')
    expect(report_query.query).to eq('SELECT bat FROM foo_bars')
  end
end