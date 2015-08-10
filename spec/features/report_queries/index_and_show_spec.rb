require 'rails_helper'

describe 'ReportQuery index and show' do
  let(:report_query) { build :report_query }
  let!(:person) { create :person }
  let(:report_query) { create :report_query, has_date_range: true, start_date_default: 'beginning_of_week' }

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

    it 'shows the start date with the default date' do
      default_date = Date.today.beginning_of_week.strftime('%m/%d/%Y')
      expect(page).to have_selector "input[value='#{default_date}']"
    end

    it "shows the end date with today's date" do
      end_date = Date.today.strftime('%m/%d/%Y')
      expect(page).to have_selector "input[value='#{end_date}']"
    end

    it 'shows the refresh button' do
      expect(page).to have_selector 'input[value="Refresh"]'
    end

    it 'shows the proper date when refreshed' do
      start_date = (Date.today - 11.days).strftime('%m/%d/%Y')
      end_date = (Date.today - 10.days).strftime('%m/%d/%Y')
      fill_in 'Start date', with: start_date
      fill_in 'End date', with: end_date
      click_on 'Refresh'
      expect(page).to have_selector "input[value='#{start_date}']"
      expect(page).to have_selector "input[value='#{end_date}']"
    end
  end
end