require 'rails_helper'

describe 'DirecTV sales CRUD actions' do
  let!(:person) { create :directv_employee, position: position }
  let(:position) { create :directv_sales_position }
  let(:directv_sale) { build :directv_sale }
  let(:directv_install_appointment) { build :directv_install_appointment }
  let!(:directv_install_time_slot) { create :directv_install_time_slot }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'directv_sale_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'directv_sale_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'directv_sale_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'directv_sale_create', permission_group: permission_group, description: description }
  let(:order_date) { directv_sale.order_date.strftime('%m/%d/%Y') }
  let(:install_date) { (directv_sale.order_date + 7.days).strftime('%m/%d/%Y') }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for creating' do
    let(:directv_customer) { create :directv_customer }
    let!(:directv_former_provider) { create :directv_former_provider }

    before(:each) do
      person.position.permissions << permission_create
      visit new_directv_customer_directv_sale_path(directv_customer)
    end

    context 'success' do
      subject {
        fill_in 'Order date', with: order_date
        fill_in 'Order number', with: directv_sale.order_number
        select directv_former_provider.name, from: "Previous Provider"
        fill_in 'Install date', with: install_date
        select directv_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
      }

      it 'has the correct page title' do
        expect(page).to have_selector('h1', text: 'New DirecTV Sale')
      end

      it 'creates a new DirecTVSale' do
        expect { subject }.to change(DirecTVSale, :count).by(1)
      end

      it 'creates a LogEntry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'redirects to DirecTVCustomers#new' do
        subject
        expect(page).to have_selector('h1', 'New DirecTV Customer')
      end
    end

    context 'failures', pending: 'Temporarily removedexit' do
      context 'date entry' do
        let(:incorrect_order_date) { (directv_sale.order_date - 25.hours).strftime('%m/%d/%Y') }
        before {
          fill_in 'Order date', with: incorrect_order_date
          fill_in 'Order number', with: directv_sale.order_number
          select directv_former_provider.name, from: "Previous Provider"
          fill_in 'Install date', with: install_date
          select directv_install_time_slot.name, from: 'Install time slot'
          click_on 'Complete Sale'
        }

        it 'does not allow the sale to be entered' do
          expect(page).to have_content('cannot be more than 24 hours in the past')
        end

        it 'renders the new template' do
          expect(page).to have_content('New DirecTV Sale')
        end
      end
    end
  end

  context 'for reading' do
    describe 'index page' do
      let(:area) { create :area }
      let(:person) { create :directv_employee }
      let!(:person_area) { create :person_area, person: person, area: area }
      let(:directv_customer_one) { create :directv_customer, person: person }
      let(:directv_customer_two) { create :directv_customer, person: person }
      let!(:directv_sale_one) {
        create :directv_sale,
               directv_customer: directv_customer_one,
               person: person
      }
      let!(:directv_sale_two) { create :directv_sale, directv_customer: directv_customer_two }
      let!(:permission) { create :permission, key: 'directv_sale_index' }

      before do
        person.position.permissions << permission
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit directv_sales_path
      end

      it 'has the correct page title' do
        expect(page).to have_selector('h1', text: 'DirecTV Sales')
      end

      it 'lists DirecTV sales' do
        expect(page).to have_content(directv_customer_one.name)
      end
    end
  end
end