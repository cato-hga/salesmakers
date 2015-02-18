require 'rails_helper'

describe ComcastLeadsController do
  let(:comcast_customer) { create :comcast_customer }
  let(:comcast_employee) { create :comcast_employee }
  let(:comcast_lead) { build :comcast_lead, comcast_customer: comcast_customer }

  before { CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email) }

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
                  ok_to_call_and_text: true
              }
        comcast_lead.reload
      end

      it 'updates the lead correctly' do
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
    subject do
      comcast_lead.save
      allow(controller).to receive(:policy).and_return double(destroy?: true)
      delete :destroy,
             id: comcast_lead.id,
             comcast_customer_id: comcast_customer.id
      comcast_lead.reload
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
  end

end