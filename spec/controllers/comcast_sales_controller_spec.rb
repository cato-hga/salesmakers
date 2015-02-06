require 'rails_helper'

describe ComcastSalesController do
  let(:comcast_customer) { create :comcast_customer }
  let(:former_provider) { create :comcast_former_provider }

  describe 'GET new' do
    before do
      get :new,
          comcast_customer_id: comcast_customer.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:comcast_sale) { build :comcast_sale }

    subject do
      CASClient::Frameworks::Rails::Filter.fake(comcast_customer.person.email)
      post :create,
           comcast_customer_id: comcast_customer.id,
           comcast_sale: {
               order_date: comcast_sale.order_date.strftime('%m/%d/%Y'),
               order_number: comcast_sale.order_number,
               tv: comcast_sale.tv,
               comcast_install_appointment_attributes: comcast_sale.comcast_install_appointment.attributes,
               comcast_former_provider_id: former_provider.id
           }
    end

    it 'increases the ComcastSales count' do
      expect { subject }.to change(ComcastSale, :count).by(1)
    end

    it 'increases the LogEntry count' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to ComcastCustomers#index' do
      subject
      expect(response).to redirect_to(comcast_customers_path)
    end
  end
end