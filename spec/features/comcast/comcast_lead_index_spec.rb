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
end