require 'rails_helper'

describe ComcastLeadsController do
  let(:comcast_customer) { create :comcast_customer, person: comcast_employee }
  let(:comcast_employee) { create :comcast_employee }
  let(:comcast_lead) { build :comcast_lead, comcast_customer: comcast_customer }

  before { CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email) }

  describe 'GET index' do
    before do
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET csv' do
    it 'returns a success status for CSV format' do
      get :csv,
          format: :csv
      expect(response).to be_success
    end

    it 'redirects an HTML format' do
      get :csv
      expect(response).to redirect_to(comcast_leads_path)
    end
  end

  describe 'GET new' do
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new, comcast_customer_id: comcast_customer.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    subject do
      allow(controller).to receive(:policy).and_return double(create?: true)
      post :create,
           comcast_customer_id: comcast_customer.id,
           comcast_lead: {
               follow_up_by: 'tomorrow',
               tv: true,
               ok_to_call_and_text: true
           }
    end

    it 'should redirect to ComcastCustomers#index' do
      subject
      expect(response).to redirect_to(comcast_customers_path)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
    it 'creates a lead' do
      expect { subject }.to change(ComcastLead, :count).by(1)
    end
    it 'assigns the correct attributes' do
      subject
      lead = ComcastLead.first
      expect(lead.follow_up_by).to eq(Date.tomorrow)
      expect(lead.tv).to eq(true)
      expect(lead.ok_to_call_and_text).to eq(true)
    end
  end

  describe 'GET edit' do
    before {
      comcast_lead.save
      allow(controller).to receive(:policy).and_return double(edit?: true)
      get :edit,
          id: comcast_lead.id,
          comcast_customer_id: comcast_customer.id
    }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH update' do
    let(:location) { create :location, display_name: 'New Location' }
    let(:project) { create :project, name: 'Comcast Retail' }
    let(:person_area) { create :person_area,
                               person: comcast_employee,
                               area: create(:area,
                                            project: project) }
    let!(:location_area) { create :location_area,
                                  location: location,
                                  area: person_area.area }
    context 'success' do
      before do
        comcast_lead.save
        allow(controller).to receive(:policy).and_return double(update?: true)
        patch :update,
              id: comcast_lead.id,
              comcast_customer_id: comcast_customer.id,
              comcast_lead: {
                  follow_up_by: Date.today + 1.week,
                  tv: false,
                  security: true,
                  ok_to_call_and_text: true,
                  comcast_customer_attributes: {
                      first_name: 'Peter',
                      last_name: 'Ortiz',
                      location_id: location.id,
                      mobile_phone: '7777777777',
                      other_phone: '8888888888',
                      person_id: comcast_employee.id
                  }
              }
        comcast_lead.reload
      end

      it 'updates the lead correctly' do
        customer = comcast_lead.comcast_customer
        customer.reload
        expect(customer.first_name).to eq('Peter')
        expect(customer.last_name).to eq('Ortiz')
        expect(customer.location).to eq(location)
        expect(customer.mobile_phone).to eq('7777777777')
        expect(customer.other_phone).to eq('8888888888')
        expect(comcast_lead.follow_up_by).to eq(Date.today + 1.week)
        expect(comcast_lead.tv).to eq(false)
        expect(comcast_lead.security).to eq(true)
        expect(comcast_lead.ok_to_call_and_text).to eq(true)
      end
      it 'creates a log entry' do
        expect(LogEntry.count).to eq(1)
        logs = LogEntry.first
        expect(logs.trackable).to eq(comcast_lead)
        expect(logs.referenceable).to eq(comcast_employee)
      end
      it 'should redirect to ComcastCustomer#index' do
        expect(response).to redirect_to(comcast_customers_path)
      end
    end

  end

  describe 'DELETE destroy' do
    let!(:reason) { create :comcast_lead_dismissal_reason }
    subject do
      comcast_lead.save
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: comcast_lead.id,
             comcast_customer_id: comcast_customer.id,
             comcast_customer: {
                 comcast_lead_dismissal_reason_id: reason.id,
                 dismissal_comment: "Test Comment!"
             }
      comcast_lead.reload
      comcast_customer.reload
    end

    it 'deactivates a lead' do
      expect { subject }.to change(comcast_lead, :active?).from(true).to(false)
    end

    it 'redirects to ComcastCustomers#index' do
      subject
      expect(response).to redirect_to(comcast_customers_path)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'attaches the comments and dismissal reason' do
      expect(comcast_customer.comcast_lead_dismissal_reason_id).to be_nil
      expect(comcast_customer.dismissal_comment).to be_nil
      subject
      expect(comcast_customer.comcast_lead_dismissal_reason_id).to eq(reason.id)
      expect(comcast_customer.dismissal_comment).to eq('Test Comment!')
    end
  end

  describe 'GET edit' do
    before {
      comcast_lead.save
      allow(controller).to receive(:policy).and_return double(reassign?: true)
      get :reassign,
          id: comcast_lead.id,
          comcast_customer_id: comcast_customer.id
    }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:reassign)
    end
  end

  describe 'PATCH reassign_lead' do
    let!(:comcast_employee_two) { create :comcast_employee, email: 'test@test.com' }
    subject {
      comcast_lead.save
      allow(controller).to receive(:policy).and_return double(reassign_to?: true)
      patch :reassign_to,
            id: comcast_lead.id,
            comcast_customer_id: comcast_customer.id,
            person_id: comcast_employee_two.id
    }

    it 'reassigns the lead' do
      expect(comcast_customer.person).to eq(comcast_employee)
      subject
      comcast_customer.reload
      expect(comcast_customer.person).to eq(comcast_employee_two)
    end
  end

  describe 'GET dismiss' do
    before do
      comcast_lead.save
      allow(controller).to receive(:policy).and_return double(dismiss?: true)
      get :dismiss,
          id: comcast_lead.id,
          comcast_customer_id: comcast_customer.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:dismiss)
    end
  end
end