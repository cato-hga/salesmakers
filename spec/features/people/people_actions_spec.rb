require 'rails_helper'

describe 'actions involving People' do
  context 'when viewing' do
    let!(:it_tech) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let!(:log_entry) { create :log_entry, trackable: person }
    let(:position) { create :position, hq: true }
    let(:person) { create :person, position: position }
    let!(:person_address) { create :person_address, person: person }
    let(:client) { create :client, name: 'Other Client' }
    let(:project) { create :project, name: 'Other Project', client: client }
    let(:area) { create :area, project: project }
    let!(:person_area) { create :person_area, person: person, area: area }
    let(:project_one) { create :project, name: 'Project One' }
    let(:project_two) { create :project, name: 'Project Two' }
    let!(:shift_one) { create :shift, project: project_one, hours: 11.2, person: person }
    let!(:shift_two) { create :shift, project: project_two, hours: 12.5, person: person }

    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit person_path(person)
    end

    it 'should show log entries on the show page' do
      visit person_path(person)
      expect(page).to have_content("Created person #{person.display_name}")
    end

    it 'should have the candidate ID' do
      candidate = create :candidate, person: person
      visit person_path(person)
      expect(page).to have_content candidate.id
    end

    it "should show the person's address" do
      expect(page).to have_content(person_address.line_1)
      expect(page).to have_content(person_address.city)
      expect(page).to have_content(person_address.state)
      expect(page).to have_content(person_address.zip)
    end

    it 'should not have a masquerade button by default' do
      expect(page).not_to have_selector 'a', text: 'Masquerade'
    end

    it 'should not show commissions for non-Vonage employees' do
      expect(page).not_to have_selector('a', text: 'Commissions')
    end

    it 'should show commissions for Vonage employees' do
      client.update name: 'Vonage'
      visit person_path(person)
      expect(page).to have_button('Commissions')
    end

    it 'should have a working link to new person creation on #index' do
      permission = create :permission, key: 'person_create'
      person.position.permissions << permission
      visit people_path
      click_on 'new_action_button'
      expect(page).to have_selector('h1', text: 'New Person')
    end

    it 'shows hours by projects for different projects' do
      expect(page).to have_content 'Project One'
      expect(page).to have_content '11.2 Hours'
      expect(page).to have_content 'Project Two'
      expect(page).to have_content '12.5 Hours'
    end

    context 'with masquerade permissions' do
      let(:masquerade_permission) { create :permission, key: 'person_masquerade' }
      let(:foobar_department) { create :department, name: 'Foobar Department' }

      before do
        it_tech.position.permissions << masquerade_permission
        person.position.update department: foobar_department
        CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
        visit person_path(person)
      end

      it 'should show the masquerade button' do
        expect(page).to have_selector 'a', text: 'Masquerade'
      end

      it 'successfully masquerades' do
        click_on 'Masquerade'
        expect(page).to have_selector 'li.has-dropdown', text: person.email
      end
    end
  end

  context 'when creating' do
    let!(:it_tech) { create :it_tech_person, position: position }
    let(:position) {
      create :it_tech_position,
             permissions: [
                 person_create_permission,
                 candidate_index_permission,
                 candidate_create_permission
             ]
    }
    let(:person_create_permission) { create :permission, key: 'person_create' }
    let(:candidate_index_permission) { create :permission, key: 'candidate_index' }
    let(:candidate_create_permission) { create :permission, key: 'candidate_create' }
    let(:client) { create :client, name: 'Other Client' }
    let(:project) { create :project, name: 'Other Project', client: client }
    let(:area) { create :area, project: project, connect_salesregion_id: '77777' }
    let(:location_area) { create :location_area, area: area }
    let!(:candidate) { create :candidate, location_area: location_area }

    before do
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    end

    it 'fills in candidate information in the new person form' do
      visit candidates_path
      click_on 'Onboard'
      expect(page).to have_selector('h1', "New Person for #{candidate.name}")
      expect(page).to have_selector('#candidate_id')
      expect(find_field('First name').value).to eq(candidate.first_name)
      expect(find_field('Last name').value).to eq(candidate.last_name)
      expect(find_field('Mobile phone').value).to eq(candidate.mobile_phone)
      expect(find_field('Personal email').value).to eq(candidate.email)
      expect(find_field('Sales rep for area (blank for manager)').value).to eq(candidate.location_area.area.connect_salesregion_id)
      expect(find_field('Zip').value).to eq(candidate.zip)
    end
  end

  context 'comcast employees' do
    context 'as an authorized manager or employee' do
      let(:department) { create :department, name: 'Comcast Retail Sales' }
      let!(:comcast_manager) { create :comcast_manager, position: position }
      let(:position) { create :comcast_sales_manager_position, department: department }
      let(:comcast_lead_customer) { create :comcast_customer, person: person }
      let(:comcast_sale_customer) { create :comcast_customer, person: person }
      let!(:comcast_sale) { create :comcast_sale, comcast_customer: comcast_lead_customer }
      let!(:comcast_lead) { create :comcast_lead, comcast_customer: comcast_sale_customer }
      let(:person) { create :comcast_employee, position: sales_specialist }
      let(:sales_specialist) { create :comcast_sales_position, department: department }
      it 'shows current leads and sales' do
        allow(Person).to receive(:visible).and_return(Person.where(id: person.id))
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
