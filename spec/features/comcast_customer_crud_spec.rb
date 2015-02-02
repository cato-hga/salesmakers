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

  context 'for creating' do
    before(:each) do
      person.position.permissions << permission_create
      visit new_comcast_customer_path
    end

    context 'success' do
      subject {
        select location.name, from: 'Location'
        fill_in 'First name', with: comcast_customer.first_name
        fill_in 'Last name', with: comcast_customer.last_name
        fill_in 'Mobile phone', with: comcast_customer.mobile_phone
        click_on 'Enter Sale'
      }

      it 'has the correct page title' do
        expect(page).to have_selector('h1', text: 'New Comcast Customer')
      end

      it 'creates a new comcast customer' do
        subject
        expect(page).to have_content(comcast_customer.first_name)
        expect(page).to have_content(comcast_customer.last_name)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
    end

    context 'failure' do
      subject {
        fill_in 'First name', with: ''
        fill_in 'Last name', with: comcast_customer.last_name
        fill_in 'Mobile phone', with: comcast_customer.mobile_phone
        click_on 'Enter Sale'
      }

      it 'renders the new template' do
        expect(page).to have_selector('h1', text: 'New Comcast Customer')
      end

      it 'renders error messages' do
        subject
        expect(page).to have_selector('.alert')
      end
    end
  end

  context 'for reading' do
    let(:now) { Time.now }
    let!(:comcast_lead) {
      create :comcast_lead,
             comcast_customer: comcast_customer,
             created_at: now
    }
    let!(:comcast_sale) {
      create :comcast_sale,
             comcast_customer: comcast_customer,
             created_at: now
    }

    before {
      person.position.permissions << permission_index
    }

    context '#index' do
      it 'displays leads' do
        visit comcast_customers_path
        expect(page).to have_selector('a', text: comcast_lead.comcast_customer.name)
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
        expect(page).not_to have_selector('a', text: comcast_customer.name)
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
          expect(page).to have_selector('a', text: '(696) 969-6969')
        end
      end

      it 'displays an "other phone" number' do
        comcast_customer.update other_phone: '9876543210'
        visit comcast_customer_path(comcast_customer)
        within '#comcast_customer' do
          expect(page).to have_selector('a', text: '(987) 654-3210')
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
            expect(page).to have_content(comcast_sale.sale_date.strftime('%m/%d/%Y'))
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
      end

      context 'without a sale' do
        before do
          comcast_sale.destroy
          visit comcast_customer_path(comcast_customer)
        end

        it 'displays the sale entry form' do
          expect(page).to have_selector('#new_comcast_sale')
        end
      end
    end
  end
end
