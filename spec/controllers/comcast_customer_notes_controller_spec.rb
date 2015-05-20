require 'rails_helper'

describe ComcastCustomerNotesController do
  let(:person) { create :person }
  let!(:comcast_customer) { create :comcast_customer }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'POST create' do
    before do
      post :create,
           comcast_customer_id: comcast_customer.id,
           comcast_customer_note: {
               note: 'This is a note.'
           }
    end

    it 'redirects to the ComcastCustomer show page' do
      expect(response).to redirect_to(comcast_customer_path(comcast_customer))
    end

    it 'increases the ComcastCustomerNote count' do
      expect(ComcastCustomerNote.count).to eq(1)
    end
  end
end