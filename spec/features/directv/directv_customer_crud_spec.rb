require 'rails_helper'

describe 'DirecTV Customer CRUD actions' do
  let!(:person) { create :directv_employee, position: position }
  let(:position) { create :directv_sales_position }
  let(:location) { create :location }
  let(:project) { create :project, name: 'DirecTV Retail' }
  let!(:directv_customer) { create :directv_customer, person: person }
  let(:person_area) {
    create :person_area,
           person: person,
           area: create(:area, project: project)
  }
  let!(:location_area) {
    create :location_area,
           location: location,
           area: person_area.area
  }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_index) { Permission.new key: 'directv_customer_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'directv_customer_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'directv_customer_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'directv_customer_create', permission_group: permission_group, description: description }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for reading' do
    let(:now) { Time.zone.now }
    let!(:directv_lead) {
      create :directv_lead,
             directv_customer: directv_customer,
             created_at: now
    }
    let!(:directv_sale) {
      create :directv_sale,
             person: directv_customer.person,
             directv_customer: directv_customer,
             created_at: now
    }
    let(:appointment) { directv_sale.directv_install_appointment }

    before {
      person.position.permissions << permission_index
    }

    context '#index' do
      it 'displays leads' do
        visit directv_customers_path
        within '#leads' do
          expect(page).to have_selector('a', text: directv_lead.directv_customer.name)
        end
      end

      it 'displays overdue leads separately' do
        directv_lead.follow_up_by = Date.yesterday
        directv_lead.save validate: false
        visit directv_customers_path
        within '#overdue_leads' do
          expect(page).to have_selector('a', text: directv_lead.directv_customer.name)
        end
      end

      it 'displays upcoming leads separately' do
        directv_lead.update follow_up_by: Date.tomorrow
        visit directv_customers_path
        within '#upcoming_leads' do
          expect(page).to have_selector('a', text: directv_lead.directv_customer.name)
        end
      end

      it 'does not display inactive leads' do
        directv_lead.update active: false
        visit directv_customers_path
        within '#leads' do
          expect(page).not_to have_selector('a', text: directv_customer.name)
        end
      end

      it 'displays recent installations' do
        appointment.install_date = Date.yesterday
        appointment.save validate: false
        visit directv_customers_path
        within '#recent_installations' do
          expect(page).to have_content(directv_customer.name)
        end
      end

      it 'displays upcoming installations' do
        appointment.update install_date: Date.tomorrow
        visit directv_customers_path
        within '#upcoming_installations' do
          expect(page).to have_content(directv_customer.name)
        end
      end
    end

    context '#show' do
      before {
        visit directv_customer_path(directv_customer)
      }

      it 'displays the customer name as the title' do
        expect(page).to have_selector('h1', text: directv_customer.name)
      end

      it 'displays a mobile phone number' do
        within '#directv_customer' do
          expect(page).to have_content "(#{directv_customer.mobile_phone[0..2]}) #{directv_customer.mobile_phone[3..5]}-#{directv_customer.mobile_phone[6..9]}"
        end
      end

      it 'displays an "other phone" number' do
        directv_customer.update other_phone: '9876543210'
        visit directv_customer_path(directv_customer)
        within '#directv_customer' do
          expect(page).to have_selector('a', text: '(987) 654-3210')
        end
      end

      it 'shows the person who entered the customer' do
        within '#directv_customer' do
          expect(page).to have_selector('a', text: person.name)
        end
      end

      it 'shows the date and time the customer was entered' do
        within '#directv_customer' do
          expect(page).to have_content(now.strftime('%l:%M%P %Z'))
        end
      end

      it 'shows comments that were entered when the customer was saved' do
        directv_customer.update comments: 'Here are customer comments'
        visit directv_customer_path(directv_customer)
        within '#directv_customer' do
          expect(page).to have_content(directv_customer.comments)
        end
      end

      context 'with a lead' do
        it 'displays the follow_up_by date' do
          directv_lead.update follow_up_by: Date.tomorrow
          visit directv_customer_path(directv_customer)
          within '#directv_lead' do
            expect(page).to have_content(Date.tomorrow.strftime('%m/%d/%Y'))
          end
        end

        it 'displays comments entered for the lead' do
          directv_lead.update comments: 'Here are lead comments'
          visit directv_customer_path(directv_customer)
          within '#directv_lead' do
            expect(page).to have_content(directv_lead.comments)
          end
        end
      end

      context 'with a sale' do
        it 'displays the sale date' do
          within '#directv_sale' do
            expect(page).to have_content(directv_sale.order_date.strftime('%m/%d/%Y'))
          end
        end

        it 'displays the person who entered the sale' do
          within '#directv_sale' do
            expect(page).to have_selector('a', text: directv_sale.person.name)
          end
        end

        it 'displays the order number' do
          within '#directv_sale' do
            expect(page).to have_content(directv_sale.order_number)
          end
        end

        it 'displays when the sale was entered' do
          within '#directv_sale' do
            expect(page).to have_content(now.strftime('%l:%M%P %Z'))
          end
        end

        it 'displays the installation date' do
          within '#directv_sale' do
            expect(page).to have_content(appointment.install_date.strftime('%m/%d/%Y'))
          end
        end

        it 'displays the installation time slot' do
          within '#directv_sale' do
            expect(page).to have_content(appointment.directv_install_time_slot.name)
          end
        end
      end

      context 'without a sale' do
        before do
          directv_sale.destroy
        end

        subject { visit directv_customer_path(directv_customer) }

        it 'does not display the sale entry form without DirecTVCustomer create? permission' do
          subject
          expect(page).not_to have_selector('#new_directv_sale')
        end

        it 'displays the sale entry form when the person has permission to create a new DirecTVCustomer' do
          person.position.permissions << permission_create
          subject
          expect(page).to have_selector('#new_directv_sale')
        end
      end
    end
  end
end