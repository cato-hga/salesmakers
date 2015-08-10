require 'rails_helper'

describe 'Followups' do
  let(:person) { create :directv_employee, position: position }
  let(:position) { create :directv_sales_position, permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'directv_customer_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'directv_customer_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:directv_customer) { create :directv_customer, person: person }

  context 'for DirecTV Leads' do
    describe 'page fields' do
      let!(:other_lead) { create :directv_lead, directv_customer: directv_customer }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit directv_customers_path
      end
      it 'are shown correctly' do
        expect(page).to have_content 'F/U By'
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
      let!(:other_lead) { create :directv_lead, directv_customer: directv_customer }
      let!(:over_week_upcoming_lead) { create :directv_lead, follow_up_by: Date.today + 8.days, directv_customer: directv_customer }
      let!(:upcoming_lead) { create :directv_lead, follow_up_by: Date.today + 6.days, directv_customer: directv_customer }
      let!(:overdue_lead) {
        lead = build :directv_lead, follow_up_by: Date.today - 1.days, directv_customer: directv_customer
        lead.save(validate: false)
        lead
      }
      before(:each) do
        @time_now = Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)
        allow(Time).to receive(:now).and_return(@time_now)
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit directv_customers_path
      end
      it 'shows when necessary' do
        expect(page).to have_content 'Other Leads'
        expect(page).to have_content 'Upcoming'
        expect(page).to have_content 'Overdue'
      end
    end
  end

  describe 'for DirecTV Installations' do

    describe 'page fields' do
      let!(:other_install_appointment) { create :directv_install_appointment, directv_sale: other_sale }
      let(:other_sale) { create :directv_sale, directv_customer: directv_customer, person: person }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit directv_customers_path
      end

      it 'are shown correctly' do
        expect(page).to have_content 'Inst Date'
        expect(page).to have_content 'Inst Time'
        expect(page).to have_content 'Phone'
        expect(page).to have_content 'Sold'
        expect(page).to have_content 'Customer'
        expect(page).to have_content 'Order Number'
      end
    end

    describe 'recent/upcoming/other installs' do
      let(:recent_install_appointment) { x = build(:directv_install_appointment,
                                                   install_date: Date.yesterday)
                                         x.save(validate: false)
                                         x}
      let!(:recent_sale) { x = build(:directv_sale,
                                  directv_customer: directv_customer,
                                  person: person,
                                  directv_install_appointment: recent_install_appointment)
                           x.save(validate: false)
                           x
      }

      let(:upcoming_install_appointment) { create :directv_install_appointment, install_date: Date.tomorrow }
      let!(:upcoming_sale) { create :directv_sale,
                                    directv_customer: directv_customer,
                                    person: person,
                                    directv_install_appointment: upcoming_install_appointment
      }

      let(:past_week_install_appointment) { x = build(:directv_install_appointment,
                                                      install_date: Date.today - 8.days)
                                            x.save(validate: false)
                                            x}
      let!(:past_week_sale) { x = build(:directv_sale,
                                     directv_customer: directv_customer,
                                     person: person,
                                     directv_install_appointment: past_week_install_appointment)
                              x.save(validate:false)

      }

      let(:future_week_install_appointment) { create :directv_install_appointment, install_date: Date.today + 8.days }
      let!(:future_week_sale) { create :directv_sale,
                                       directv_customer: directv_customer,
                                       person: person,
                                       directv_install_appointment: future_week_install_appointment }


      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        visit directv_customers_path
      end
      it 'show when necessary' do
        expect(page).to have_content(Date.yesterday.strftime('%m/%d/%Y'))
        expect(page).to have_content(Date.tomorrow.strftime('%m/%d/%Y'))
      end
      it 'do not show for one week in the past' do
        expect(page).not_to have_content (Date.today - 8.days).strftime('%m/%d/%Y')
      end
      it 'do not show for one week in the future' do
        expect(page).not_to have_content (Date.today + 8.days).strftime('%m/%d/%Y')
      end
    end
  end
end
