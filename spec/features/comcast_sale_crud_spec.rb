require 'rails_helper'

describe 'Comcast sales CRUD actions' do
  let!(:person) { create :comcast_employee }
  let(:comcast_sale) { build :comcast_sale }
  let(:permission_index) { create :permission, key: 'comcast_sale_index' }
  let(:permission_update) { create :permission, key: 'comcast_sale_update' }
  let(:permission_destroy) { create :permission, key: 'comcast_sale_destroy' }
  let(:permission_create) { create :permission, key: 'comcast_sale_create' }
  let(:sale_date) { comcast_sale.sale_date.strftime('%m/%d/%Y') }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for creating' do
    let(:comcast_customer) { create :comcast_customer }

    before(:each) do
      person.position.permissions << permission_create
      visit new_comcast_customer_comcast_sale_path(comcast_customer)
    end

    context 'success' do
      subject {
        fill_in 'Sale date', with: sale_date
        fill_in 'Order number', with: comcast_sale.order_number
        check 'Television'
        click_on 'Save'
      }

      it 'has the correct page title' do
        expect(page).to have_selector('h1', text: 'New Comcast Sale')
      end

      it 'creates a new ComcastSale' do
        expect { subject }.to change(ComcastSale, :count).by(1)
      end

      it 'creates a LogEntry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'redirects to ComcastCustomers#new' do
        subject
        expect(page).to have_selector('h1', 'New Comcast Customer')
      end
    end
  end

end