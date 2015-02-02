require 'rails_helper'

describe ComcastLeadsController do
  let(:comcast_customer) { create :comcast_customer }
  let(:comcast_employee) { create :comcast_employee }
  let(:comcast_lead) { build :comcast_lead, comcast_customer: comcast_customer }

  before { CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email) }

  describe 'GET new' do
    before { get :new, comcast_customer_id: comcast_customer.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    before do
      post :create,
           comcast_customer_id: comcast_customer.id,
           comcast_lead: {
               tv: true
           }
    end

    it 'should redirect to ComcastCustomers#new' do
      expect(response).to redirect_to(new_comcast_customer_path)
    end
  end

  describe 'DELETE destroy' do
    subject do
      comcast_lead.save
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
  end

end