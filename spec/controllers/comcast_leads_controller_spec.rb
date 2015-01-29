require 'rails_helper'

describe ComcastLeadsController do
  let(:comcast_customer) { create :comcast_customer }
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
    let(:comcast_employee) { create :comcast_employee }
    let(:comcast_lead) { build :comcast_lead }
    before do
      CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
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

end