require 'rails_helper'

describe 'management scorecard' do
  let(:area) { create :area, project: project }
  let(:project) { create :project, name: 'Vonage Retail' }
  let(:outside_area) { create :area }

  let(:rep) { create :person }
  let!(:rep_person_area) { create :person_area, person: rep, area: area }
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  let!(:vonage_sale_this_week) { create :vonage_sale, person: rep, sale_date: Date.today }
  let!(:vonage_sale_last_week) { create :vonage_sale, person: rep, sale_date: Date.today - 1.week }
  let!(:vonage_sale_two_weeks_ago) { build :vonage_sale, person: rep, sale_date: Date.today - 2.weeks }
  let!(:vonage_sale_three_weeks_ago) { build :vonage_sale, person: rep, sale_date: Date.today - 3.weeks }

  let!(:shift_this_week) { create :shift, person: rep, date: Date.today }
  let!(:shift_last_week) { create :shift, person: rep, date: Date.today - 3.weeks }
  let!(:shift_two_weeks_ago) { create :shift, person: rep, date: Date.today - 3.weeks }
  let!(:shift_three_weeks_ago) { create :shift, person: rep, date: Date.today - 3.weeks }
  let!(:vonage_refund_this_week) { create :vonage_refund, person: rep, refund_date: Date.today }
  let!(:vonage_refund_last_week) { create :vonage_refund, person: rep, refund_date: Date.today - 1.week }
  let!(:vonage_refund_two_weeks_ago) { create :vonage_refund, person: rep, refund_date: Date.today - 2.weeks }
  let!(:vonage_refund_three_weeks_ago) { create :vonage_refund, person: rep, refund_date: Date.today - 3.weeks }

  let(:manager) { create :person, position: position }
  let!(:manager_person_area) { create :person_area, person: manager, area: area, manages: true }
  let(:position) { create :position, permissions: [scorecard_permission] }
  let(:scorecard_permission) { create :permission, key: 'area_management_scorecard' }

  let(:outside_area_rep) { create :person }
  let!(:outside_area_rep_person_area) { create :person_area, person: outside_area_rep, area: outside_area }

  before do
    vonage_sale_two_weeks_ago.import = true
    vonage_sale_three_weeks_ago.import = true
    vonage_sale_two_weeks_ago.save
    vonage_sale_three_weeks_ago.save
    CASClient::Frameworks::Rails::Filter.fake(manager.email)
    visit management_scorecard_path
  end

  describe 'visibility' do
    it 'shows the rep from inside the area' do
      expect(page).to have_content rep.display_name
    end

    it 'does not show the rep from outside the area' do
      expect(page).not_to have_content outside_area_rep.display_name
    end
  end

  describe 'sales statistics' do
    it 'lists sales for this week' do
      expect(page).to have_selector '#this_week .sales', text: '1'
    end

    it 'lists sales for last week' do
      expect(page).to have_selector '#last_week .sales', text: '1'
    end

    it 'lists sales for two weeks ago' do
      expect(page).to have_selector '#two_weeks_ago .sales', text: '1'
    end

    it 'lists sales for three weeks ago' do
      expect(page).to have_selector '#three_weeks_ago .sales', text: '1'
    end

    it 'lists total sales for a rep' do
      expect(page).to have_selector '#four_week_totals .sales', text: '5'
    end

    it 'lists grand total of sales' do
      expect(page).to have_selector '#four_week_totals #grand_totals .sales', text: '5'
    end
  end
end