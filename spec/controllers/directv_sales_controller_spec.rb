require 'rails_helper'

describe DirecTVSalesController do
  let(:directv_customer) { create :directv_customer }
  let(:directv_employee) { create :directv_employee }
  let(:directv_sale) {
    build :directv_sale,
          directv_customer: directv_customer,
          person: directv_employee
  }
  let(:former_provider) { create :directv_former_provider }

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
      directv_sale.save
      get :csv,
          format: :csv
      expect(response).to be_success
    end


    it 'redirects an HTML format' do
      get :csv
      expect(response).to redirect_to(directv_sales_path)
    end
  end

  describe 'GET new' do
    before do
      get :new,
          directv_customer_id: directv_customer.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:directv_sale) { build :directv_sale }

    subject do
      CASClient::Frameworks::Rails::Filter.fake(directv_customer.person.email)
      post :create,
           directv_customer_id: directv_customer.id,
           directv_sale: {
               order_date: directv_sale.order_date.strftime('%m/%d/%Y'),
               order_number: directv_sale.order_number,
               directv_install_appointment_attributes: directv_sale.directv_install_appointment.attributes,
               directv_former_provider_id: former_provider.id
           }
    end

    it 'increases the DirecTVSales count' do
      expect { subject }.to change(DirecTVSale, :count).by(1)
    end

    it 'increases the LogEntry count' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to DirecTVCustomers#index' do
      subject
      expect(response).to redirect_to(directv_customers_path)
    end
  end
end