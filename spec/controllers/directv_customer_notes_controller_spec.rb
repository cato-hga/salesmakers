require 'rails_helper'

describe DirecTVCustomerNotesController do
  let(:person) { create :person }
  let!(:directv_customer) { create :directv_customer }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'POST create' do
    before do
      post :create,
           directv_customer_id: directv_customer.id,
           directv_customer_note: {
               note: 'This is a note.'
           }
    end

    it 'redirects to the DirecTVCustomer show page' do
      expect(response).to redirect_to(directv_customer_path(directv_customer))
    end

    it 'increases the DirecTVCustomerNote count' do
      expect(DirecTVCustomerNote.count).to eq(1)
    end
  end
end