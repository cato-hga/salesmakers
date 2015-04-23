require 'rails_helper'

describe 'Sprint Retail sales scoreboard' do
  let(:person) { create :person }
  let(:location_area) { create :location_area, area: area }
  let(:area) { create :area, project: project }
  let(:project) { create :project, client: client }
  let(:client) { create :client }

  let(:permission) { create :permission, key: 'sprint_sale_scoreboard' }
  let(:viewer) { create :person, position: position }
  let(:position) { create :position, permissions: [permission] }

  let!(:day_sales_counts) {
    [create(:day_sales_count,
            saleable: client,
            sales: 29,
            activations: 28,
            new_accounts: 27),
     create(:day_sales_count,
            saleable: project,
            sales: 26,
            activations: 25,
            new_accounts: 24),
     create(:day_sales_count,
            saleable: area,
            sales: 23,
            activations: 22,
            new_accounts: 21),
     create(:day_sales_count,
            saleable: person,
            sales: 20,
            activations: 19,
            new_accounts: 18),
     create(:day_sales_count,
            saleable: location_area,
            sales: 17,
            activations: 16,
            new_accounts: 15)]
  }

  before { visit scoreboard_sprint_sales_path }

  it 'should have the proper title' do
    expect(page).to have_selector('h1', text: 'Sprint Sales Scoreboard')
  end

  it 'should have the rep counts by default' do
    expect(page).to have_selector('td', text: day_sales_counts[3].sales.to_s)
    expect(page).to have_selector('td', text: day_sales_counts[3].activations.to_s)
    expect(page).to have_selector('td', text: day_sales_counts[3].new_accounts.to_s)
  end
end