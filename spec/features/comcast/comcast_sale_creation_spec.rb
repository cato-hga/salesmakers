require 'rails_helper'

describe 'Comcast Sale creation' do
  let(:person) { create :comcast_employee, position: position }
  let(:position) { create :comcast_sales_position, permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'comcast_customer_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'comcast_customer_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:comcast_customer) { create :comcast_customer, person: person }
  let!(:comcast_install_time_slot) { create :comcast_install_time_slot }
  let!(:inactive_comcast_install_time_slot) { create :comcast_install_time_slot, name: "Inactive", active: false }
  describe 'new page' do
    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_comcast_customer_comcast_sale_path comcast_customer.id
      end

      it 'shows the New Comcast Sale page' do
        expect(page).to have_content('New Comcast Sale')
      end

      it 'has locations' do
        expect(page).to have_content(comcast_customer.name)
      end


      it 'should only show active time slots' do
        expect(page).to have_content(comcast_install_time_slot.name)
        expect(page).not_to have_content(inactive_comcast_install_time_slot.name)
      end
    end

    context 'for unauthorized users' do
      let(:unauth_person) { create :person }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
        visit new_comcast_customer_path
      end

      it 'shows the You are not authorized page' do
        expect(page).to have_content('Your access does not allow you to view this page')
      end
    end
  end

  describe 'form submission' do
    let!(:previous_provider) { create :comcast_former_provider }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit new_comcast_customer_comcast_sale_path comcast_customer.id
    end

    context 'with all blank data' do
      it 'renders :new and shows all relevant error messages' do
        click_on 'Complete Sale'
        expect(page).to have_content("Order date can't be blank")
        expect(page).to have_content("Order number is the wrong length")
        expect(page).to have_content("Order number is not a number")
        expect(page).to have_content("Tv or at least one other product must be selected")
        expect(page).to have_content("Internet or at least one other product must be selected")
        expect(page).to have_content("Phone or at least one other product must be selected")
        expect(page).to have_content("Security or at least one other product must be selected")
        expect(page).to have_content("install date can't be blank")
      end
    end

    context 'with an invalid date' do
      it 'renders :new and shows a clear error message', pending: 'Cannot do anything with this because of Chronic'
    end

    context 'with other invalid information' do
      it 'renders :new and should retain information', pending: 'Dont know what to do' do #Error messages handled above
        fill_in 'Order date', with: 'today'
        fill_in 'Order number', with: '1234567891015'
        select previous_provider.name, from: 'Previous Provider'
        fill_in 'Install date', with: 'tomorrow'
        select comcast_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
        expect(page).to have_content('today')
        check 'Customer agrees to receive text message reminders(s) and/or phone calls'
      end

      it 'does not have invalid dates left over', pending: 'NOPE'
    end

    describe 'with valid data' do
      before(:each) do
        fill_in 'Order date', with: 'today'
        fill_in 'Order number', with: '1234567891015'
        select previous_provider.name, from: 'Previous Provider'
        check 'Television'
        check 'Security'
        fill_in 'Install date', with: 'tomorrow'
        select comcast_install_time_slot.name, from: 'Install time slot'
        check 'Customer agrees to receive text message reminder(s) and/or phone calls.'
        click_on 'Complete Sale'
      end
      it 'flashes a success message' do
        expect(page).to have_content 'Sale saved'
      end
      it 'redirects to My Customers' do
        expect(page).to have_content 'My Customers'
        expect(page).to have_content comcast_customer.name
      end
      it 'shows the sale/installation information' do
        sale = ComcastSale.first
        expect(page).to have_content sale.order_date.strftime('%m/%d/%Y')
        expect(page).to have_content sale.order_number
        expect(page).to have_content sale.comcast_customer.first_name
      end
    end

    describe 'from comcast lead page' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit comcast_customer_path comcast_customer.id
      end
      it 'shows the form and all fields' do
        expect(page).to have_content 'Order date'
        expect(page).to have_content 'Order number'
        expect(page).to have_content 'Previous Provider'
        expect(page).to have_content 'Services'
        expect(page).to have_content 'Install date'
        expect(page).to have_content 'Install time slot'
      end
      context 'submission failure' do #submission success in the main page - no need to test
        before(:each) do
          fill_in 'Order date', with: 'today'
          fill_in 'Order number', with: '1234567891015'
          select previous_provider.name, from: 'Previous Provider'
          fill_in 'Install date', with: 'tomorrow'
          select comcast_install_time_slot.name, from: 'Install time slot'
          click_on 'Complete Sale'
        end
        it 'redirects to the new sale page' do
          expect(page).to have_content 'New Comcast Sale'
        end
        it 'renders errors' do
          expect(page).to have_content 'at least one other product must be selected'
        end
        it 'retains information', pending: 'Dont know what to do'
      end
    end
  end
end