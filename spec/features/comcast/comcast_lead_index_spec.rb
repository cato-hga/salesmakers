require 'rails_helper'

describe 'Comcast leads index' do
  let(:area) { create :area }
  let(:person) { create :comcast_employee }
  let!(:person_area) { create :person_area, person: person, area: area }
  let(:comcast_customer_one) { create :comcast_customer, person: person }
  let(:comcast_customer_two) { create :comcast_customer, person: person }
  let!(:comcast_lead_one) { create :comcast_lead, comcast_customer: comcast_customer_one }
  let!(:comcast_lead_two) { create :comcast_lead, comcast_customer: comcast_customer_two }
  let!(:permission) { create :permission, key: 'comcast_lead_index' }

  before do
    person.position.permissions << permission
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit comcast_leads_path
  end

  it 'has the correct page title' do
    expect(page).to have_selector('h1', text: 'Comcast Leads')
  end

  it 'lists Comcast leads' do
    expect(page).to have_content(comcast_customer_one.name)
  end
  it 'has section displaying if Lead has been followed up on' do
    expect(page).to have_content('Has Comments')
  end
  it 'displays yes if lead has a comment' do
      comcast_lead_one.update comments: 'Test Comment'
      visit comcast_leads_path
      expect(page).to have_content('Yes')

  end
  it 'displays no if lead does not have a comment' do
      comcast_lead_one.update comments: nil
      visit comcast_leads_path
      expect(page).to have_content('No')
  end
end