require 'rails_helper'

describe DirecTVLeadsController do
  let(:directv_customer) { create :directv_customer, person: directv_employee }
  let(:directv_employee) { create :directv_employee }
  let(:directv_lead) { build :directv_lead, directv_customer: directv_customer }

  before { CASClient::Frameworks::Rails::Filter.fake(directv_employee.email) }

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
      expect(response).to redirect_to(directv_leads_path)
    end
  end

  describe 'GET new' do
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new, directv_customer_id: directv_customer.id }

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
           directv_customer_id: directv_customer.id,
           directv_lead: {
               follow_up_by: 'tomorrow',
               ok_to_call_and_text: true
           }
    end

    it 'should redirect to DirecTVCustomers#index' do
      subject
      expect(response).to redirect_to(directv_customers_path)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
    it 'creates a lead' do
      expect { subject }.to change(DirecTVLead, :count).by(1)
    end
    it 'assigns the correct attributes' do
      subject
      lead = DirecTVLead.first
      expect(lead.follow_up_by).to eq(Date.tomorrow)
      expect(lead.ok_to_call_and_text).to eq(true)
    end
  end

  describe 'GET edit' do
    before {
      directv_lead.save
      allow(controller).to receive(:policy).and_return double(edit?: true)
      get :edit,
          id: directv_lead.id,
          directv_customer_id: directv_customer.id
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
    let(:project) { create :project, name: 'DirecTV Retail' }
    let(:person_area) { create :person_area,
                               person: directv_employee,
                               area: create(:area,
                                            project: project) }
    let!(:location_area) { create :location_area,
                                  location: location,
                                  area: person_area.area }
    context 'success' do
      before do
        directv_lead.save
        allow(controller).to receive(:policy).and_return double(update?: true)
        patch :update,
              id: directv_lead.id,
              directv_customer_id: directv_customer.id,
              directv_lead: {
                  follow_up_by: Date.today + 1.week,
                  ok_to_call_and_text: true,
                  directv_customer_attributes: {
                      first_name: 'Peter',
                      last_name: 'Ortiz',
                      location_id: location.id,
                      mobile_phone: '7777777777',
                      other_phone: '8888888888',
                      person_id: directv_employee.id
                  }
              }
        directv_lead.reload
      end

      it 'updates the lead correctly' do
        customer = directv_lead.directv_customer
        customer.reload
        expect(customer.first_name).to eq('Peter')
        expect(customer.last_name).to eq('Ortiz')
        expect(customer.location).to eq(location)
        expect(customer.mobile_phone).to eq('7777777777')
        expect(customer.other_phone).to eq('8888888888')
        expect(directv_lead.follow_up_by).to eq(Date.today + 1.week)
        expect(directv_lead.ok_to_call_and_text).to eq(true)
      end
      it 'creates a log entry' do
        expect(LogEntry.count).to eq(1)
        logs = LogEntry.first
        expect(logs.trackable).to eq(directv_lead)
        expect(logs.referenceable).to eq(directv_employee)
      end
      it 'should redirect to DirecTVCustomer#index' do
        expect(response).to redirect_to(directv_customers_path)
      end
    end

  end

  describe 'DELETE destroy' do
    let!(:reason) { create :directv_lead_dismissal_reason }
    subject do
      directv_lead.save
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: directv_lead.id,
             directv_customer_id: directv_customer.id,
             directv_customer: {
                 directv_lead_dismissal_reason_id: reason.id,
                 dismissal_comment: "Test Comment!"
             }
      directv_lead.reload
      directv_customer.reload
    end

    it 'deactivates a lead' do
      expect { subject }.to change(directv_lead, :active?).from(true).to(false)
    end

    it 'redirects to DirecTVCustomers#index' do
      subject
      expect(response).to redirect_to(directv_customers_path)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'attaches the comments and dismissal reason' do
      expect(directv_customer.directv_lead_dismissal_reason_id).to be_nil
      expect(directv_customer.dismissal_comment).to be_nil
      subject
      expect(directv_customer.directv_lead_dismissal_reason_id).to eq(reason.id)
      expect(directv_customer.dismissal_comment).to eq('Test Comment!')
    end
  end

  describe 'GET edit' do
    before {
      directv_lead.save
      allow(controller).to receive(:policy).and_return double(reassign?: true)
      get :reassign,
          id: directv_lead.id,
          directv_customer_id: directv_customer.id
    }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:reassign)
    end
  end

  describe 'PATCH reassign_lead' do
    let!(:directv_employee_two) { create :directv_employee, email: 'test@test.com' }
    subject {
      directv_lead.save
      allow(controller).to receive(:policy).and_return double(reassign_to?: true)
      patch :reassign_to,
            id: directv_lead.id,
            directv_customer_id: directv_customer.id,
            person_id: directv_employee_two.id
    }

    it 'reassigns the lead' do
      expect(directv_customer.person).to eq(directv_employee)
      subject
      directv_customer.reload
      expect(directv_customer.person).to eq(directv_employee_two)
    end
  end

  describe 'GET dismiss' do
    before do
      directv_lead.save
      allow(controller).to receive(:policy).and_return double(dismiss?: true)
      get :dismiss,
          id: directv_lead.id,
          directv_customer_id: directv_customer.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:dismiss)
    end
  end
end