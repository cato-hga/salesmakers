require 'rails_helper'

describe ComcastLead do
  let(:entered_lead) {
    lead = build :comcast_lead, follow_up_by: Date.yesterday
    lead.save validate: false
    lead
  }
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


  it 'does not require the follow up date to be in the future when dismissing' do
    entered_lead.update active: false
    expect(entered_lead).to be_valid
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

    specify 'overdue leads do not include inactives' do
      overdue_lead.active = false
      overdue_lead.save validate: false
      overdue_leads = ComcastLead.overdue
      expect(overdue_leads).not_to include(overdue_lead)
    end

    it 'scopes upcoming leads to follow_up_by dates within 7 days' do
      upcoming_leads = ComcastLead.upcoming
      expect(upcoming_leads).to include(upcoming_lead)
      expect(upcoming_leads).to include(today_lead)
      expect(upcoming_leads).not_to include(overdue_lead)
      expect(upcoming_leads).not_to include(later_lead)
      expect(upcoming_leads).not_to include(no_date_lead)
    end

    specify 'upcoming leads do not include inactives' do
      upcoming_lead.update active: false
      upcoming_leads = ComcastLead.upcoming
      expect(upcoming_leads).not_to include(upcoming_lead)
    end

    it 'scopes later and no date leads together' do
      later_leads = ComcastLead.not_upcoming_or_overdue
      expect(later_leads).to include(later_lead)
      expect(later_leads).to include(no_date_lead)
      expect(later_leads).not_to include(overdue_lead)
      expect(later_leads).not_to include(upcoming_lead)
      expect(later_leads).not_to include(today_lead)
    end

    specify 'not upcoming and not overdue do not include inactives' do
      no_date_lead.update active: false
      later_leads = ComcastLead.not_upcoming_or_overdue
      expect(later_leads).not_to include(no_date_lead)
    end
  end
end