require 'rails_helper'

describe 'Sprint Retail sales scoreboard' do
  let!(:person) { create :person }
  let!(:location_area) { create :location_area, area: territory }
  let(:territory_type) { create :area_type, name: 'Sprint Territory' }
  let(:market_type) { create :area_type, name: 'Sprint Market' }
  let(:region_type) { create :area_type, name: 'Sprint Region' }
  let(:territory) { create :area, project: project, area_type: territory_type, ancestry: region.id.to_s + '/' + market.id.to_s }
  let(:market) { create :area, project: project, area_type: market_type, ancestry: region.id.to_s }
  let(:region) { create :area, project: project, area_type: region_type }
  let(:project) { create :project, client: client }
  let!(:client) { create :client, name: 'Sprint' }
  let!(:sprint_retail) { create :project, name: "Sprint Retail" }
  let!(:star) { create :project, name: "STAR" }

  let(:permission) { create :permission, key: 'sprint_sale_index' }
  let!(:viewer) { create :person, position: position }
  let(:position) { create :position, permissions: [permission] }

  let!(:sprint_sales) {
    20.times do
      sale = create :sprint_sale,
             sale_date: Date.today,
             location: location_area.location,
             person: person

    end
  }

  before do
    CASClient::Frameworks::Rails::Filter.fake(viewer.email)
  end

  context 'when viewing reps' do
    before do
      visit scoreboard_sprint_sales_path
    end

    it 'should have the proper title' do
      expect(page).to have_selector('h1', text: 'Sprint Sales Scoreboard')
    end

    it 'should have the rep counts by default' do
      expect(page).to have_selector('td', text: '20')
    end
  end

  context 'when viewing locations' do
    before do
      create :sprint_sale,
                    sale_date: Date.today,
                    location: location_area.location,
                    person: create(:person)
      visit scoreboard_sprint_sales_path
      select 'Locations', from: 'depth'
      click_on 'Go'
    end

    it 'should have the proper counts' do
      expect(page).to have_selector('td', text: '21')
    end
  end

  context 'when viewing territories' do
    before do
      2.times do
        create :sprint_sale,
               sale_date: Date.today,
               location: location_area.location,
               person: create(:person)
      end
      visit scoreboard_sprint_sales_path
      select 'Territories', from: 'depth'
      click_on 'Go'
    end

    it 'should have the proper counts' do
      expect(page).to have_selector('td', text: '22')
    end
  end

  context 'when viewing markets' do
    before do
      3.times do
        create :sprint_sale,
               sale_date: Date.today,
               location: location_area.location,
               person: create(:person)
      end
      visit scoreboard_sprint_sales_path
      select 'Markets', from: 'depth'
      click_on 'Go'
    end

    it 'should have the proper counts' do
      expect(page).to have_selector('td', text: '23')
    end
  end
end