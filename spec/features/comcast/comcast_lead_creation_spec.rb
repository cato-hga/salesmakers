require 'rails_helper'

describe 'Comcast Lead Creation' do
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
  describe 'new page' do
    context 'for authorized users' do
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit new_comcast_customer_comcast_lead_path comcast_customer.id
      end

      it 'shows the New Lead page' do
        expect(page).to have_content('New Lead')
      end

      it 'has locations' do
        expect(page).to have_content(comcast_customer.name)
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
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit new_comcast_customer_comcast_lead_path comcast_customer.id
    end
    context 'with all blank data' do
      it 'renders :new and shows all relevant error messages' do
        click_on 'Save as Lead'
        expect(page).to have_content('Tv or at least one other')
        expect(page).to have_content('Internet or at least one other')
        expect(page).to have_content('Phone or at least one other')
        expect(page).to have_content('Security or at least one other')
        expect(page).to have_content('Ok to call and text must be checked to save as a lead')
      end
    end
    context 'with an invalid date' do
      it 'renders :new and shows a clear error message' do
        fill_in 'Follow up by', with: 'totallywrongdate'
        check 'Television'
        check 'Customer agrees to be contacted by phone or text message'
        click_on 'Save as Lead'
        expect(page).to have_content 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      end
    end
    context 'with other invalid information' do
      it 'renders :new and should retain information' do #Error messages handled above
        fill_in 'Follow up by', with: 'tomorrow'
        check 'Television'
        check 'Security'
        click_on 'Save as Lead'
        expect(page).to have_field('comcast_lead_follow_up_by', with: (Date.current + 1.day).strftime('%m/%d/%Y'))
      end
    end

    describe 'with valid data' do
      before(:each) do
        fill_in 'Follow up by', with: 'tomorrow'
        check 'Television'
        check 'Security'
        check 'Customer agrees to be contacted by phone or text message'
        click_on 'Save as Lead'
      end
      it 'flashes a success message' do
        expect(page).to have_content('Lead saved')
      end
      it 'redirects to My Customers' do
        expect(page).to have_content('My Customers')
        expect(page).to have_content(comcast_customer.name)
      end
      it 'shows the lead information' do
        expect(page).to have_content((Date.current + 1.day).strftime('%m/%d/%Y'))
      end
    end
  end
end
