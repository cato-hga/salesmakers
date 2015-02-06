require 'rails_helper'

describe 'Comcast sales CRUD actions' do
  let!(:person) { create :comcast_employee, position: position }
  let(:position) { create :comcast_sales_position }
  let(:comcast_sale) { build :comcast_sale }
  let(:comcast_install_appointment) { build :comcast_install_appointment }
  let!(:comcast_install_time_slot) { create :comcast_install_time_slot }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'comcast_sale_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'comcast_sale_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'comcast_sale_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'comcast_sale_create', permission_group: permission_group, description: description }
  let(:order_date) { comcast_sale.order_date.strftime('%m/%d/%Y') }
  let(:install_date) { (comcast_sale.order_date + 7.days).strftime('%m/%d/%Y') }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for creating' do
    let(:comcast_customer) { create :comcast_customer }
    let!(:comcast_former_provider) { create :comcast_former_provider }

    before(:each) do
      person.position.permissions << permission_create
      visit new_comcast_customer_comcast_sale_path(comcast_customer)
    end

    context 'success' do
      subject {
        fill_in 'Order date', with: order_date
        fill_in 'Order number', with: comcast_sale.order_number
        select comcast_former_provider.name, from: "Previous Provider"
        check 'Television'
        fill_in 'Install date', with: install_date
        select comcast_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
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

    context 'failures' do
      context 'date entry' do
        let(:incorrect_order_date) { (comcast_sale.order_date - 25.hours).strftime('%m/%d/%Y') }
        before {
          fill_in 'Order date', with: incorrect_order_date
          fill_in 'Order number', with: comcast_sale.order_number
          select comcast_former_provider.name, from: "Previous Provider"
          check 'Television'
          fill_in 'Install date', with: install_date
          select comcast_install_time_slot.name, from: 'Install time slot'
          click_on 'Complete Sale'
        }

        it 'does not allow the sale to be entered' do
          expect(page).to have_content('cannot be more than 24 hours in the past')
        end

        it 'renders the new template' do
          expect(page).to have_content('New Comcast Sale')
        end
      end
    end


  end
end