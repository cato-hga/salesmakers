require 'rails_helper'

describe 'Comcast Customer CRUD actions' do
  let!(:person) { create :comcast_employee, position: position }
  let(:position) { create :comcast_sales_position }
  let(:location) { create :location }
  let(:project) { create :project, name: 'Comcast Retail' }
  let!(:comcast_customer) { create :comcast_customer, person: person }
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
  let(:permission_index) { Permission.new key: 'comcast_customer_index', permission_group: permission_group, description: description }
  let(:permission_update) { Permission.new key: 'comcast_customer_update', permission_group: permission_group, description: description }
  let(:permission_destroy) { Permission.new key: 'comcast_customer_destroy', permission_group: permission_group, description: description }
  let(:permission_create) { Permission.new key: 'comcast_customer_create', permission_group: permission_group, description: description }

  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'for reading' do
    let(:now) { Time.zone.now }
    let!(:comcast_lead) {
      create :comcast_lead,
             comcast_customer: comcast_customer,
             created_at: now
    }
    let!(:comcast_sale) {
      create :comcast_sale,
             person: comcast_customer.person,
             comcast_customer: comcast_customer,
             created_at: now
    }
    let(:appointment) { comcast_sale.comcast_install_appointment }

    before {
      person.position.permissions << permission_index
    }

    context '#index' do
      it 'displays leads' do
        visit comcast_customers_path
        within '#leads' do
          expect(page).to have_selector('a', text: comcast_lead.comcast_customer.name)
        end
      end

      it 'displays overdue leads separately' do
        comcast_lead.follow_up_by = Date.yesterday
        comcast_lead.save validate: false
        visit comcast_customers_path
        within '#overdue_leads' do
          expect(page).to have_selector('a', text: comcast_lead.comcast_customer.name)
        end
      end

      it 'displays upcoming leads separately' do
        comcast_lead.update follow_up_by: Date.tomorrow
        visit comcast_customers_path
        within '#upcoming_leads' do
          expect(page).to have_selector('a', text: comcast_lead.comcast_customer.name)
        end
      end

      it 'does not display inactive leads' do
        comcast_lead.update active: false
        visit comcast_customers_path
        within '#leads' do
          expect(page).not_to have_selector('a', text: comcast_customer.name)
        end
      end

      it 'displays recent installations' do
        appointment.install_date = Date.yesterday
        appointment.save validate: false
        visit comcast_customers_path
        within '#recent_installations' do
          expect(page).to have_content(comcast_customer.name)
        end
      end

      it 'displays upcoming installations' do
        appointment.update install_date: Date.tomorrow
        visit comcast_customers_path
        within '#upcoming_installations' do
          expect(page).to have_content(comcast_customer.name)
        end
      end
    end

    context '#show' do
      before {
        visit comcast_customer_path(comcast_customer)
      }

      it 'displays the customer name as the title' do
        expect(page).to have_selector('h1', text: comcast_customer.name)
      end

      it 'displays a mobile phone number' do
        within '#comcast_customer' do
          expect(page).to have_content "(#{comcast_customer.mobile_phone[0..2]}) #{comcast_customer.mobile_phone[3..5]}-#{comcast_customer.mobile_phone[6..9]}"
        end
      end

      it 'displays an "other phone" number' do
        comcast_customer.update other_phone: '8005551001'
        visit comcast_customer_path(comcast_customer)
        within '#comcast_customer' do
          expect(page).to have_selector('a', text: '(800) 555-1001')
        end
      end

      it 'shows the person who entered the customer' do
        within '#comcast_customer' do
          expect(page).to have_selector('a', text: person.name)
        end
      end

      it 'shows the date and time the customer was entered' do
        within '#comcast_customer' do
          expect(page).to have_content(now.strftime('%l:%M%P %Z'))
        end
      end

      it 'shows comments that were entered when the customer was saved' do
        comcast_customer.update comments: 'Here are customer comments'
        visit comcast_customer_path(comcast_customer)
        within '#comcast_customer' do
          expect(page).to have_content(comcast_customer.comments)
        end
      end

      context 'with a lead' do
        it 'displays the follow_up_by date' do
          comcast_lead.update follow_up_by: Date.tomorrow
          visit comcast_customer_path(comcast_customer)
          within '#comcast_lead' do
            expect(page).to have_content(Date.tomorrow.strftime('%m/%d/%Y'))
          end
        end

        it 'displays the services the customer is interested in' do
          within '#comcast_lead' do
            expect(page).to have_content('Television')
          end
        end

        it 'displays comments entered for the lead' do
          comcast_lead.update comments: 'Here are lead comments'
          visit comcast_customer_path(comcast_customer)
          within '#comcast_lead' do
            expect(page).to have_content(comcast_lead.comments)
          end
        end
      end

      context 'with a sale' do
        it 'displays the sale date' do
          within '#comcast_sale' do
            expect(page).to have_content(comcast_sale.order_date.strftime('%m/%d/%Y'))
          end
        end

        it 'displays the person who entered the sale' do
          within '#comcast_sale' do
            expect(page).to have_selector('a', text: comcast_sale.person.name)
          end
        end

        it 'displays the order number' do
          within '#comcast_sale' do
            expect(page).to have_content(comcast_sale.order_number)
          end
        end

        it 'displays the services ordered' do
          within '#comcast_sale' do
            expect(page).to have_content('Television')
          end
        end

        it 'displays when the sale was entered' do
          within '#comcast_sale' do
            expect(page).to have_content(now.strftime('%l:%M%P %Z'))
          end
        end

        it 'displays the installation date' do
          within '#comcast_sale' do
            expect(page).to have_content(appointment.install_date.strftime('%m/%d/%Y'))
          end
        end

        it 'displays the installation time slot' do
          within '#comcast_sale' do
            expect(page).to have_content(appointment.comcast_install_time_slot.name)
          end
        end
      end

      context 'without a sale' do
        before do
          comcast_sale.destroy
        end

        subject { visit comcast_customer_path(comcast_customer) }

        it 'does not display the sale entry form without ComcastCustomer create? permission' do
          subject
          expect(page).not_to have_selector('#new_comcast_sale')
        end

        it 'displays the sale entry form when the person has permission to create a new ComcastCustomer' do
          person.position.permissions << permission_create
          subject
          expect(page).to have_selector('#new_comcast_sale')
        end
      end
    end
  end
end
