require 'rails_helper'

describe ComcastEodsController do

  before { CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email) }

  describe 'GET new', pending: 'pending' do
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

  describe 'POST create', pending: 'pending' do
    context 'success' do
      before do
        post :create,
             comcast_customer_id: comcast_customer.id,
             comcast_lead: {
                 tv: true,
                 ok_to_call_and_text: true
             }
      end

      it 'should redirect to ComcastCustomers#index' do
        expect(response).to redirect_to(comcast_customers_path)
      end
    end
    context 'failure' do

      it 'redirects to ComcastEOD#new'
    end
  end
end

