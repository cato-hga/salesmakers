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
  it 'has section displaying if Lead has been followed up on' do
    expect(page).to have_content('Has Comments')
  end
  it 'displays yes if lead has a comment'do
    directv_lead_one.update comments: 'Test Comment'
    visit directv_leads_path
    expect(page).to have_content('Yes')
  end
  it 'displays no if lead does not have a comment' do
    directv_lead_one.update comments: nil
    visit directv_leads_path
    expect(page).to have_content('No')
  end
end