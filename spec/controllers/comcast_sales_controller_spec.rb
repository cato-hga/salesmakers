require 'rails_helper'

describe ComcastSalesController do
  let(:comcast_customer) { create :comcast_customer }

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
               sale_date: comcast_sale.sale_date.strftime('%m/%d/%Y'),
               order_number: comcast_sale.order_number,
               tv: comcast_sale.tv,
               comcast_install_appointment_attributes: comcast_sale.comcast_install_appointment.attributes
           }
    end

    it 'increases the ComcastSales count' do
      expect { subject }.to change(ComcastSale, :count).by(1)
    end

    it 'increases the LogEntry count' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to ComcastCustomers#new' do
      subject
      expect(response).to redirect_to(new_comcast_customer_path)
    end
  end
end