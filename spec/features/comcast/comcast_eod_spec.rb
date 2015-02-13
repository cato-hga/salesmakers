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
    it 'handles true/false radio buttons correctly' #Test that true/false on the radio button is OK
    it 'redirects to ComcastCustomer#index'
    it 'flashes a success message'
    it 'creates a log entry' #may not be testable here
  end

  describe 'submission failure' do
    it 'renders the new page'
    it 'flashes errors'
  end

end