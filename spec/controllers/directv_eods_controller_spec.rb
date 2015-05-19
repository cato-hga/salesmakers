require 'rails_helper'

describe DirecTVEodsController do
  let(:person) { create :directv_employee, position: position }
  let(:position) { create :directv_sales_position }
  let!(:project) { create :project, name: 'DirecTV Retail' }

  before(:each) do
    allow(controller).to receive(:policy).and_return double(new?: true,
                                                            index?: true,
                                                            create?: true)
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET new' do
    before {
      get :new
    }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:location) { create :location }
    let(:person_area) { create :person_area,
                               person: person,
                               area: create(:area,
                                            project: project) }
    let!(:location_area) { create :location_area,
                                  location: location,
                                  area: person_area.area }
    let!(:eod_date) { DateTime.now }
    context 'success' do
      before do
        post :create,
             directv_eod: {
                 eod_date: eod_date,
                 location_id: location.id,
                 person_id: person.id,
                 sales_pro_visit: true,
                 sales_pro_visit_takeaway: 'Sales Pro Takeaway',
                 directv_visit: true,
                 directv_visit_takeaway: 'DirecTV Visit Takeaway',
                 cloud_training: true,
                 cloud_training_takeaway: 'Cloud Training Takeaway',
             }
      end

      it 'should redirect to DirecTVCustomers#index' do
        expect(response).to redirect_to(directv_customers_path)
      end

      it 'assigns proper attributes' do
        eod = DirecTVEod.first
        expect(eod.location).to eq(location)
        expect(eod.sales_pro_visit).to eq(true)
        expect(eod.sales_pro_visit_takeaway).to eq('Sales Pro Takeaway')
        expect(eod.directv_visit).to eq(true)
        expect(eod.directv_visit_takeaway).to eq('DirecTV Visit Takeaway')
        expect(eod.cloud_training).to eq(true)
        expect(eod.cloud_training_takeaway).to eq('Cloud Training Takeaway')
        expect(eod.person).to eq(person)
      end

      it 'creates a log entry' do
        expect(LogEntry.count).to eq(1)
      end
    end

    context 'failure' do
      before do
        post :create,
             directv_eod: {
                 eod_date: eod_date,
                 sales_pro_visit: true,
                 sales_pro_visit_takeaway: 'Sales Pro Takeaway',
                 directv_visit: true,
                 directv_visit_takeaway: 'DirecTV Visit Takeaway',
                 cloud_training: true,
                 cloud_training_takeaway: 'Cloud Training Takeaway',
             }
      end
      it 'redirects to DirecTVEOD#new' do
        expect(response).to render_template(:new)
      end
    end
  end
end

