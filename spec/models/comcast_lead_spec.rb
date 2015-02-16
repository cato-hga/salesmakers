require 'rails_helper'

describe ComcastLead do
  subject { build :comcast_lead }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a comcast_customer_id' do
    subject.comcast_customer_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires at least one service selection' do
    subject.tv = false
    subject.internet = false
    subject.phone = false
    subject.security = false
    expect(subject).not_to be_valid
    subject.tv = true
    expect(subject).to be_valid
    subject.tv = false; subject.internet = true
    expect(subject).to be_valid
    subject.internet = false; subject.phone = true
    expect(subject).to be_valid
    subject.phone = false; subject.security = true
    expect(subject).to be_valid
  end

  it 'requires that the follow up date be in the future' do
    subject.follow_up_by = Date.today
    expect(subject).not_to be_valid
    subject.follow_up_by = Date.yesterday
    expect(subject).not_to be_valid
    subject.follow_up_by = Date.tomorrow
    expect(subject).to be_valid
  end

  it 'requires that the ok_to_call_and_text be true' do
    subject.ok_to_call_and_text = false
    expect(subject).not_to be_valid
  end

  describe 'scopes' do
    let!(:overdue_lead) {
      lead = build :comcast_lead, follow_up_by: Date.yesterday
      lead.save validate: false
      lead
    }
    let!(:upcoming_lead) { create :comcast_lead, follow_up_by: Date.tomorrow }
    let!(:today_lead) {
      lead = build :comcast_lead, follow_up_by: Date.today
      lead.save validate: false
      lead
    }
    let!(:later_lead) { create :comcast_lead, follow_up_by: Date.today + 8.days }
    let!(:no_date_lead) { create :comcast_lead, follow_up_by: nil }

    it 'scopes overdue leads' do
      overdue_leads = ComcastLead.overdue
      expect(overdue_leads).to include(overdue_lead)
      expect(overdue_leads).not_to include(upcoming_lead)
      expect(overdue_leads).not_to include(today_lead)
      expect(overdue_leads).not_to include(later_lead)
      expect(overdue_leads).not_to include(no_date_lead)
    end

    it 'scopes upcoming leads to follow_up_by dates within 7 days' do
      upcoming_leads = ComcastLead.upcoming
      expect(upcoming_leads).to include(upcoming_lead)
      expect(upcoming_leads).to include(today_lead)
      expect(upcoming_leads).not_to include(overdue_lead)
      expect(upcoming_leads).not_to include(later_lead)
      expect(upcoming_leads).not_to include(no_date_lead)
    end

    it 'scopes later and no date leads together' do
      later_leads = ComcastLead.not_upcoming_or_overdue
      expect(later_leads).to include(later_lead)
      expect(later_leads).to include(no_date_lead)
      expect(later_leads).not_to include(overdue_lead)
      expect(later_leads).not_to include(upcoming_lead)
      expect(later_leads).not_to include(today_lead)
    end

    it 'does not include inactive leads in the default scope' do
      no_date_lead.update active: false
      expect(ComcastLead.all).not_to include no_date_lead
    end

    context 'dismissible' do
      let(:comcast_manager) { create :comcast_manager }
      let(:comcast_employee) { create :comcast_employee }
      let(:other_comcast_employee) { create :comcast_employee, email: 'test2@cc.salesmakersinc.com' }

      let!(:comcast_area) { create :area, person_areas: [manager_person_area,
                                                         employee_person_area,
                                                         other_employee_person_area] }
      let(:manager_person_area) { create :person_area, person: comcast_manager, manages: true }
      let(:employee_person_area) { create :person_area, person: comcast_employee, manages: false }
      let(:other_employee_person_area) { create :person_area, person: other_comcast_employee, manages: false }

      let(:comcast_employee_customer) { create :comcast_customer, person: comcast_employee }
      let(:comcast_manager_customer) { create :comcast_customer, person: comcast_manager }
      let(:other_comcast_employee_customer) { create :comcast_customer, person: other_comcast_employee }

      let!(:employee_comcast_lead) { create :comcast_lead, comcast_customer: comcast_employee_customer }
      let!(:other_employee_comcast_lead) { create :comcast_lead, comcast_customer: other_comcast_employee_customer }
      let!(:manager_comcast_lead) { create :comcast_lead, comcast_customer: comcast_manager_customer }

      it 'allows managers to dismiss their employees leads' do
        dismissible = ComcastLead.dismissible(comcast_manager)
        expect(dismissible).to include(employee_comcast_lead)
        expect(dismissible).to include(other_employee_comcast_lead)
      end

      it 'does not allow an employee to dismiss another employees lead' do
        dismissible = ComcastLead.dismissible(comcast_employee)
        expect(dismissible).not_to include(other_employee_comcast_lead)
      end
      it 'does not allow an employee to dismiss their managers leads' do
        dismissible = ComcastLead.dismissible(comcast_employee)
        expect(dismissible).not_to include(manager_comcast_lead)
        dismissible = ComcastLead.dismissible(other_comcast_employee)
        expect(dismissible).not_to include(manager_comcast_lead)
      end

      it 'allows an employee to dismiss their own lead' do
        dismissible = ComcastLead.dismissible(comcast_employee)
        expect(dismissible).to include(employee_comcast_lead)
        dismissible = ComcastLead.dismissible(other_comcast_employee)
        expect(dismissible).to include(other_employee_comcast_lead)
        dismissible = ComcastLead.dismissible(comcast_manager)
        expect(dismissible).to include(manager_comcast_lead)
      end
    end
  end

end