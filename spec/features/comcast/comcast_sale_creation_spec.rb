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
      @time_now = Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)
      allow(Time).to receive(:now).and_return(@time_now)
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
      before do
        fill_in 'Order date', with: 'totallywrongdate'
        fill_in 'Order number', with: '1234567891015'
        check 'Television'
        select previous_provider.name, from: 'Previous Provider'
        fill_in 'Install date', with: 'reallywrongdate'
        select comcast_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
      end
      it 'renders :new and shows a clear error message' do
        expect(page).to have_content "Order date entered could not be used - there may be a typo or invalid date. Please re-enter"
        expect(page).to have_content "Install date entered could not be used - there may be a typo or invalid date. Please re-enter"
      end

      it 'does not have invalid dates left over' do
        expect(page).to have_field('comcast_sale_order_date', with: '')
        expect(page).to have_field('comcast_sale_comcast_install_appointment_attributes_install_date', with: '')
      end
    end

    context 'with a past date' do
      before do
        fill_in 'Order date', with: Date.today
        fill_in 'Order number', with: '1234567891015'
        check 'Television'
        select previous_provider.name, from: 'Previous Provider'
        fill_in 'Install date', with: Date.yesterday
        select comcast_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
      end

      it 'flashes an error message' do
        expect(page).to have_content 'cannot be in the past.'
      end
    end

    context 'with date too far in the future' do
      before do
        fill_in 'Order date', with: Date.today
        fill_in 'Order number', with: '1234567891015'
        check 'Television'
        select previous_provider.name, from: 'Previous Provider'
        fill_in 'Install date', with: 61.days.from_now
        select comcast_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
      end

      it 'flashes an error message' do
        expect(page).to have_content 'must be within 60 days from today.'
      end

    end

    context 'with other invalid information' do
      it 'renders :new and should retain information' do #Error messages handled above
        fill_in 'Order date', with: 'today'
        fill_in 'Order number', with: '1234567891015'
        select previous_provider.name, from: 'Previous Provider'
        fill_in 'Install date', with: 'tomorrow'
        select comcast_install_time_slot.name, from: 'Install time slot'
        click_on 'Complete Sale'
        expect(page).to have_field('comcast_sale_order_date', with: Date.current.strftime('%m/%d/%Y'))
        expect(page).to have_field('comcast_sale_comcast_install_appointment_attributes_install_date', with: (Date.current + 1.day).strftime('%m/%d/%Y'))
      end
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
      it 'does not add a comcast_lead relationship' do
        sale = ComcastSale.first
        expect(sale.comcast_lead_id).to be_nil
      end
    end

    describe 'from comcast lead page' do
      before(:each) do
        @time_now = Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)
        allow(Time).to receive(:now).and_return(@time_now)
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

      context 'submission success' do #most submission success in the main page - no need to test
        it 'does adds a comcast_lead relationship' do
          fill_in 'Order date', with: 'today'
          fill_in 'Order number', with: '1234567891015'
          select previous_provider.name, from: 'Previous Provider'
          check 'Television'
          check 'Security'
          fill_in 'Install date', with: 'tomorrow'
          select comcast_install_time_slot.name, from: 'Install time slot'
          check 'Customer agrees to receive text message reminder(s) and/or phone calls.'
          click_on 'Complete Sale'
          sale = ComcastSale.first
          expect(sale.comcast_lead_id).not_to be_nil
        end
      end

      context 'submission failure' do
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
        it 'renders :new and should retain information' do #Error messages handled above
          expect(page).to have_field('comcast_sale_order_date', with: Date.today.strftime('%m/%d/%Y'))
          expect(page).to have_field('comcast_sale_comcast_install_appointment_attributes_install_date', with: (Date.current + 1.day).strftime('%m/%d/%Y'))
        end
      end
    end
  end
end