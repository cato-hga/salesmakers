require 'rails_helper'

describe DirecTVCustomersController do
  let(:person) { create :directv_employee, position: position }
  let(:position) { create :directv_sales_position }
  let!(:project) { create :project, name: 'DirecTV Retail' }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    allow(controller).to receive(:policy).and_return double(new?: true,
                                                            index?: true,
                                                            show?: true)
  end

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    let!(:directv_customer) { create :directv_customer }

    before { get :show, id: directv_customer.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'returns a success status with a sale' do
      create :directv_sale,
             directv_customer: directv_customer,
             person: person
      get :show, id: directv_customer.id
      expect(response).to be_success
    end

    it 'returns a success status with a lead' do
      create :directv_lead, directv_customer: directv_customer
      get :show, id: directv_customer.id
      expect(response).to be_success
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'returns a success status' do
      expect(response).to be_success
    end
    it 'renders the index template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:new_customer) { build :directv_customer }

    before(:each) do
      allow(controller).to receive(:policy).and_return double(create?: true)
    end

    context 'success' do
      let(:attrs) {
        {
            location_id: new_customer.location_id,
            first_name: new_customer.first_name,
            last_name: new_customer.last_name,
            mobile_phone: new_customer.mobile_phone,
            person_id: person.id,
        }
      }

      context 'saving as lead or entering sale' do
        subject { post :create, directv_customer: attrs, save_as_lead: 'false' }

        it 'creates a directv customer' do
          expect { subject }.to change(DirecTVCustomer, :count).by(1)
        end

        it 'creates a log entry' do
          expect { subject }.to change(LogEntry, :count).by(1)
        end
      end

      context 'when "Enter Sale" is clicked' do
        it 'redirects to directv_sale#new' do
          post :create, directv_customer: attrs, save_as_lead: 'false'
          directv_customer = DirecTVCustomer.first
          expect(response).to redirect_to(new_directv_customer_directv_sale_path(directv_customer))
        end
      end

      context 'when "Save as Lead" is clicked' do
        it 'redirects to directv_lead#new' do
          post :create, directv_customer: attrs, save_as_lead: 'true'
          directv_customer = DirecTVCustomer.first
          expect(response).to redirect_to(new_directv_customer_directv_lead_path(directv_customer))
        end
      end

      context 'failure' do
        subject do
          post :create,
               directv_customer: {
                   first_name: '',
                   last_name: new_customer.last_name,
                   mobile_phone: new_customer.mobile_phone,
                   person_id: person.id
               }
        end
        it 'should render the new template' do
          expect(subject).to render_template(:new)
        end
      end
    end
  end
end
