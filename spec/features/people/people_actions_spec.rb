require 'rails_helper'

describe 'actions involving People' do
  context 'when viewing' do
    let!(:it_tech) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let!(:log_entry) { create :log_entry, trackable: person }
    let(:person) { create :person }
    let!(:person_address) { create :person_address, person: person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
    end

    before do
      person.position.update hq: true
      visit person_path(person)
    end

    it 'should show log entries on the show page' do

      expect(page).to have_content("Created person #{person.display_name}")
    end

    it "should show the person's address" do
      expect(page).to have_content(person_address.line_1)
      expect(page).to have_content(person_address.city)
      expect(page).to have_content(person_address.state)
      expect(page).to have_content(person_address.zip)
    end
  end

  context 'comcast employees' do
    context 'as an authorized manager or employee' do
      let!(:comcast_manager) { create :comcast_manager, position: position }
      let(:position) { create :comcast_sales_manager_position }
      let(:comcast_lead_customer) { create :comcast_customer, person: person }
      let(:comcast_sale_customer) { create :comcast_customer, person: person }
      let!(:comcast_sale) { create :comcast_sale, comcast_customer: comcast_lead_customer }
      let!(:comcast_lead) { create :comcast_lead, comcast_customer: comcast_sale_customer }
      let(:person) { create :comcast_employee, position: sales_specialist }
      let(:sales_specialist) { create :comcast_sales_position }
      it 'shows current leads and sales' do
        allow(Person).to receive(:visible).and_return(Array[person])
        CASClient::Frameworks::Rails::Filter.fake(comcast_manager.email)
        visit person_path(person)
        expect(page).to have_content('Leads')
        expect(page).to have_content('Recent and Upcoming Installations')
      end
    end

    context 'as an unauthorized manager or employee' do
      let!(:other_manager) { create :person, position: position }
      let(:position) { create :position }
      let(:comcast_lead_customer) { create :comcast_customer, person: person }
      let(:comcast_sale_customer) { create :comcast_customer, person: person }
      let!(:comcast_sale) { create :comcast_sale, comcast_customer: comcast_lead_customer }
      let!(:comcast_lead) { create :comcast_lead, comcast_customer: comcast_sale_customer }
      let(:person) { create :comcast_employee, position: sales_specialist }
      let(:sales_specialist) { create :comcast_sales_position }
      it 'does not show current leads and sales' do
        CASClient::Frameworks::Rails::Filter.fake(other_manager.email)
        visit person_path(person)
        expect(page).not_to have_content('Leads')
        expect(page).not_to have_content('Recent and Upcoming Installations')
      end
    end
  end
end