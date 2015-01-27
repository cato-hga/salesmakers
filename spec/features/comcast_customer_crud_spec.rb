require 'rails_helper'

describe 'Comcast Customer CRUD actions' do
  let!(:person) { create :comcast_employee }
  let(:location) { create :location }
  let(:project) { create :project, name: 'Comcast Retail' }
  let(:person_area) {
    create :person_area,
           person: person,
           area: create(:area, project: project)
  }
  let!(:location_area) {
    create :location_area,
           location: location,
           area: person_area.area
  }
  let(:permission_index) { create :permission, key: 'comcast_customer_index' }
  let(:permission_update) { create :permission, key: 'comcast_customer_update' }
  let(:permission_destroy) { create :permission, key: 'comcast_customer_destroy' }
  let(:permission_create) { create :permission, key: 'comcast_customer_create' }


  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for creating' do
    let(:comcast_customer) { build :comcast_customer }
    before(:each) do
      person.position.permissions << permission_create
      visit new_comcast_customer_path
    end

    context 'success' do
      subject {
        select location.name, from: 'Location'
        fill_in 'First name', with: comcast_customer.first_name
        fill_in 'Last name', with: comcast_customer.last_name
        fill_in 'Mobile phone', with: comcast_customer.mobile_phone
        click_on 'Enter Sale'
      }

      it 'has the correct page title' do
        expect(page).to have_selector('h1', text: 'New Comcast Customer')
      end

      it 'creates a new comcast customer' do
        subject
        expect(page).to have_content(comcast_customer.first_name)
        expect(page).to have_content(comcast_customer.last_name)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
    end

    context 'failure' do
      subject {
        fill_in 'First name', with: ''
        fill_in 'Last name', with: comcast_customer.last_name
        fill_in 'Mobile phone', with: comcast_customer.mobile_phone
        click_on 'Enter Sale'
      }

      it 'renders the new template' do
        expect(page).to have_selector('h1', text: 'New Comcast Customer')
      end

      it 'renders error messages' do
        subject
        expect(page).to have_selector('.alert')
      end
    end
  end

end
