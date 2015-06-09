require 'rails_helper'

describe 'ReportQuery index and show' do
  let(:report_query) { build :report_query }
  let!(:person) { create :person }
  let(:report_query) { create :report_query }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    person.position.permissions << create(:permission, key: report_query.permission_key)
  end

  context 'for the index page' do
    before do
      visit report_queries_path
    end

    it 'has the category name of the report' do
      expect(page).to have_content report_query.category_name
    end

    it 'has a link to the report' do
      expect(page).to have_selector 'a', text: report_query.name
    end
  end

  context 'for showing' do
    before do
      visit report_query_path(report_query)
    end

    it 'shows the proper title' do
      expect(page).to have_selector 'h1', text: report_query.name
    end

    it 'shows the table header' do
      expect(page).to have_selector 'th', text: 'Column Name'
    end

    it 'shows the table data' do
      expect(page).to have_selector 'td', text: 'YADA YADA'
    end
  end
end