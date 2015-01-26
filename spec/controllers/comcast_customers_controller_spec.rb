require 'rails_helper'

describe ComcastCustomersController do

  describe 'GET new' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new
    end
    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the index template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:new_customer) { build :comcast_customer }
    let(:person) { create :it_tech_person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      allow(controller).to receive(:policy).and_return double(create?: true)
    end
    context 'success' do
      subject do
        post :create,
             comcast_customer: {
                 first_name: new_customer.first_name,
                 last_name: new_customer.last_name,
                 mobile_phone: new_customer.mobile_phone,
                 person_id: person.id
             }
      end

      it 'creates a comcast customer' do
        expect { subject }.to change(ComcastCustomer, :count).by(1)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'redirects to comcast_sale#new', pending: 'Comcast Sales not created' do
        expect(subject).to redirect_to(new_comcast_sales_path)
      end
    end
  end
end