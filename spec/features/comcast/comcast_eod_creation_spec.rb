require 'rails_helper'

describe 'Comcast End of Day' do
  let(:person) { create :comcast_employee, position: position }
  let(:position) { create :comcast_sales_position, permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'comcast_customer_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'comcast_customer_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:comcast_customer) { create :comcast_customer, person: person }
  let(:location) { create :location }
  let(:project) { create :project, name: 'Comcast Retail' }
  let(:person_area) { create :person_area,
                             person: person,
                             area: create(:area,
                                          project: project) }
  let!(:location_area) { create :location_area,
                                location: location,
                                area: person_area.area }

  describe 'eod page' do
    context 'for unauthorized users' do
      let(:unauth_person) { create :person }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_comcast_eod_path
      end
      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end

    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_comcast_eod_path
      end

      it 'shows the EOD form' do
        expect(page).to have_content('Comcast End Of Day')
        expect(page).to have_css('#comcast_eod_sales_pro_visit_true')
        expect(page).to have_css('#comcast_eod_sales_pro_visit_false')
        expect(page).to have_css('#comcast_eod_sales_pro_visit_takeaway')
        expect(page).to have_css('#comcast_eod_comcast_visit_true')
        expect(page).to have_css('#comcast_eod_comcast_visit_false')
        expect(page).to have_css('#comcast_eod_comcast_visit_takeaway')
        expect(page).to have_css('#comcast_eod_cloud_training_true')
        expect(page).to have_css('#comcast_eod_cloud_training_false')
        expect(page).to have_css('#comcast_eod_cloud_training_takeaway')
      end
      it 'has locations' do
        expect(page).to have_content(location.name)
      end
    end
  end

  describe 'submission success' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit new_comcast_eod_path
      select location.name, from: 'comcast_eod_location_id'
      choose 'comcast_eod_sales_pro_visit_true'
      choose 'comcast_eod_comcast_visit_true'
      choose 'comcast_eod_cloud_training_false'
    end
    it 'handles true/false radio buttons correctly' do #Test that true/false on the radio button is OK
      choose 'comcast_eod_sales_pro_visit_true'
      choose 'comcast_eod_comcast_visit_true'
      choose 'comcast_eod_cloud_training_false'
      click_on 'Complete End Of Day'
      eod = ComcastEod.first
      expect(eod.comcast_visit).to eq(true)
      expect(eod.sales_pro_visit).to eq(true)
      expect(eod.cloud_training).to eq(false)
    end
    it 'redirects to ComcastCustomer#index' do
      click_on 'Complete End Of Day'
      expect(page).to have_content('My Leads')
    end
    it 'flashes a success message' do
      click_on 'Complete End Of Day'
      expect(page).to have_content('End of Day report saved successfully')
    end
    it 'assigns all attributes' do
      fill_in 'comcast_eod_cloud_training_takeaway', with: 'Test Cloud Takeaway'
      fill_in 'comcast_eod_sales_pro_visit_takeaway', with: 'Test Sales Pro Takeaway'
      fill_in 'comcast_eod_comcast_visit_takeaway', with: 'Test Comcast Takeaway'
      click_on 'Complete End Of Day'
      eod = ComcastEod.first
      expect(eod.location).to eq(location)
      expect(eod.person).to eq(person)
      expect(eod.sales_pro_visit_takeaway).to eq('Test Sales Pro Takeaway')
      expect(eod.comcast_visit_takeaway).to eq('Test Comcast Takeaway')
      expect(eod.cloud_training_takeaway).to eq('Test Cloud Takeaway')
    end
  end

  describe 'submission failure' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit new_comcast_eod_path
      click_on 'Complete End Of Day'
    end

    it 'renders the new page' do
      expect(page).to have_content('Comcast End Of Day')
      expect(page).to have_css('#comcast_eod_sales_pro_visit_true')
      expect(page).to have_css('#comcast_eod_sales_pro_visit_false')
      expect(page).to have_css('#comcast_eod_sales_pro_visit_takeaway')
      expect(page).to have_css('#comcast_eod_comcast_visit_true')
      expect(page).to have_css('#comcast_eod_comcast_visit_false')
      expect(page).to have_css('#comcast_eod_comcast_visit_takeaway')
      expect(page).to have_css('#comcast_eod_cloud_training_true')
      expect(page).to have_css('#comcast_eod_cloud_training_false')
      expect(page).to have_css('#comcast_eod_cloud_training_takeaway')
    end
    it 'flashes errors' do
      expect(page).to have_css('.alert.alert-box')
      expect(page).to have_content("Location can't be blank")
    end
  end

end