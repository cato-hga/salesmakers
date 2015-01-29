require 'rails_helper'

describe 'Comcast lead CRUD actions' do
  context 'for creation' do
    let(:comcast_customer) { create :comcast_customer }
    let(:comcast_lead) { build :comcast_lead }
    let!(:comcast_employee) { create :comcast_employee }

    subject do
      visit new_comcast_customer_comcast_lead_path(comcast_customer)
      check 'Television'
      click_on 'Save as Lead'
    end

    before do
      CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
    end

    it 'has the correct title' do
      visit new_comcast_customer_comcast_lead_path(comcast_customer)
      expect(page).to have_selector('h1', text: 'New Lead: ' + comcast_customer.name)
    end

    it 'creates a ComcastLead' do
      expect { subject }.to change(ComcastLead, :count).by(1)
    end

    it 'creates a LogEntry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end
end