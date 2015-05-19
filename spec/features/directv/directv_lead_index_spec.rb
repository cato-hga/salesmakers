require 'rails_helper'

describe 'DirecTV leads index' do
  let(:area) { create :area }
  let(:person) { create :directv_employee }
  let!(:person_area) { create :person_area, person: person, area: area }
  let(:directv_customer_one) { create :directv_customer, person: person }
  let(:directv_customer_two) { create :directv_customer, person: person }
  let!(:directv_lead_one) { create :directv_lead, directv_customer: directv_customer_one }
  let!(:directv_lead_two) { create :directv_lead, directv_customer: directv_customer_two }
  let!(:permission) { create :permission, key: 'directv_lead_index' }

  before do
    person.position.permissions << permission
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit directv_leads_path
  end

  it 'has the correct page title' do
    expect(page).to have_selector('h1', text: 'DirecTV Leads')
  end

  it 'lists DirecTV leads' do
    expect(page).to have_content(directv_customer_one.name)
  end
end