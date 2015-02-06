require 'rails_helper'

describe 'Followups' do
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

  context 'for Comcast Leads' do
    describe 'page fields' do
      let!(:other_lead) { create :comcast_lead, comcast_customer: comcast_customer }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit comcast_customers_path
      end
      it 'are shown correctly' do
        expect(page).to have_content 'F/U By'
        expect(page).to have_content 'Services'
        expect(page).to have_content 'Phone'
        expect(page).to have_content 'Saved'
        expect(page).to have_content 'Name'
      end

      it 'always have headings' do
        expect(page).to have_content 'Other Leads'
        expect(page).to have_content 'Upcoming'
      end
    end

    describe 'overdue/upcoming/other leads' do
      let!(:other_lead) { create :comcast_lead, comcast_customer: comcast_customer }
      let!(:over_week_upcoming_lead) { create :comcast_lead, follow_up_by: Date.today + 8.days, comcast_customer: comcast_customer }
      let!(:upcoming_lead) { create :comcast_lead, follow_up_by: Date.today + 6.days, comcast_customer: comcast_customer }
      let!(:overdue_lead) {
        lead = build :comcast_lead, follow_up_by: Date.today - 1.days, comcast_customer: comcast_customer
        lead.save(validate: false)
        lead
      }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit comcast_customers_path
      end
      it 'shows when necessary' do
        expect(page).to have_content 'Other Leads'
        expect(page).to have_content 'Upcoming'
        expect(page).to have_content 'Overdue'
      end
    end
  end

  describe 'for Comcast Installations' do

    describe 'page fields' do
      let!(:other_install_appointment) { create :comcast_install_appointment, comcast_sale: other_sale }
      let(:other_sale) { create :comcast_sale, comcast_customer: comcast_customer, person: person }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit comcast_customers_path
      end
      it 'are shown correctly' do
        expect(page).to have_content 'Inst Date'
        expect(page).to have_content 'Inst Time'
        expect(page).to have_content 'Services'
        expect(page).to have_content 'Phone'
        expect(page).to have_content 'Sold'
        expect(page).to have_content 'Customer'
        expect(page).to have_content 'Order Number'
      end
    end

    describe 'recent/upcoming/other installs' do
      let(:recent_install_appointment) { create :comcast_install_appointment, install_date: Date.yesterday }
      let!(:recent_sale) { create :comcast_sale,
                                  comcast_customer: comcast_customer,
                                  person: person,
                                  comcast_install_appointment: recent_install_appointment
      }

      let(:upcoming_install_appointment) { create :comcast_install_appointment, install_date: Date.tomorrow }
      let!(:upcoming_sale) { create :comcast_sale,
                                    comcast_customer: comcast_customer,
                                    person: person,
                                    comcast_install_appointment: upcoming_install_appointment
      }

      let(:past_week_install_appointment) { create :comcast_install_appointment, install_date: Date.today - 8.days }
      let!(:past_week_sale) { create :comcast_sale,
                                     comcast_customer: comcast_customer,
                                     person: person,
                                     comcast_install_appointment: past_week_install_appointment
      }

      let(:future_week_install_appointment) { create :comcast_install_appointment, install_date: Date.today + 8.days }
      let!(:future_week_sale) { create :comcast_sale,
                                       comcast_customer: comcast_customer,
                                       person: person,
                                       comcast_install_appointment: future_week_install_appointment }


      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit comcast_customers_path
      end
      it 'show when necessary' do
        expect(page).to have_content(Date.yesterday.strftime('%m/%d/%Y'))
        expect(page).to have_content(Date.tomorrow.strftime('%m/%d/%Y'))
      end
      it 'do not show for one week in the past'
      it 'do not show for one week in the future'
    end
  end
end
