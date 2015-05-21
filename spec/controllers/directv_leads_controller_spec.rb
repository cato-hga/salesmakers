require 'rails_helper'

describe DirecTVLeadsController do
  let(:directv_customer) { create :directv_customer }
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
    context 'success' do
      before do
        directv_lead.save
        allow(controller).to receive(:policy).and_return double(update?: true)
        patch :update,
              id: directv_lead.id,
              directv_customer_id: directv_customer.id,
              directv_lead: {
                  follow_up_by: Date.today + 1.week,
                  ok_to_call_and_text: true
              }
        directv_lead.reload
      end

      it 'updates the lead correctly' do
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
    subject do
      directv_lead.save
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: directv_lead.id,
             directv_customer_id: directv_customer.id
      directv_lead.reload
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
  end

end