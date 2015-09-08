# == Schema Information
#
# Table name: comcast_leads
#
#  id                  :integer          not null, primary key
#  comcast_customer_id :integer          not null
#  follow_up_by        :date
#  tv                  :boolean          default(FALSE), not null
#  internet            :boolean          default(FALSE), not null
#  phone               :boolean          default(FALSE), not null
#  security            :boolean          default(FALSE), not null
#  ok_to_call_and_text :boolean          default(FALSE), not null
#  comments            :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  active              :boolean          default(TRUE), not null
#

require 'rails_helper'

describe ComcastLead do
  let(:entered_lead) {
    lead = build :comcast_lead, follow_up_by: Date.yesterday
    lead.save validate: false
    lead
  }
  let(:note) { build :comcast_customer_note, comcast_customer: entered_lead.comcast_customer }

  subject { build :comcast_lead }

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
    subject.follow_up_by = Date.current
    expect(subject).not_to be_valid
    subject.follow_up_by = Date.current - 1.day
    expect(subject).not_to be_valid
    subject.follow_up_by = Date.current + 1.day
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

  it 'reflects the ComcastCustomer name as comcast_customer_name' do
    expect(subject.comcast_customer_name).to eq(subject.comcast_customer.name)
  end

  it 'reflects the ComcastCustomer mobile phone as comcast_customer_mobile_phone' do
    expect(subject.comcast_customer_mobile_phone).to eq(subject.comcast_customer.mobile_phone)
  end

  it 'reflects the ComcastCustomer other phone as comcast_customer_other_phone' do
    expect(subject.comcast_customer_other_phone).to eq(subject.comcast_customer.other_phone)
  end

  describe '.overdue_by_ten' do
    it 'returns true if the follow up date is 10 days in the past if there are no notes' do
      expect(entered_lead.overdue_by_ten).to eq(false)
      entered_lead.update follow_up_by: Date.today - 10.days
      expect(entered_lead.overdue_by_ten).to eq(false)
      entered_lead.update follow_up_by: Date.today - 11.days
      expect(entered_lead.overdue_by_ten).to eq(true)
    end
    it 'returns true if the last note was 10 days in the past or more' do
      note.save
      expect(entered_lead.overdue_by_ten).to eq(false)
      note.update created_at: Date.today - 10.days
      expect(entered_lead.overdue_by_ten).to eq(false)
      note.update created_at: Date.today - 11.days
      expect(entered_lead.overdue_by_ten).to eq(true)
    end
  end

  describe '.overdue_by_twenty_one' do
    it 'returns true if the follow up date is 10 days in the past if there are no notes' do
      expect(entered_lead.overdue_by_twenty_one).to eq(false)
      entered_lead.update follow_up_by: Date.today - 21.days
      expect(entered_lead.overdue_by_twenty_one).to eq(false)
      entered_lead.update follow_up_by: Date.today - 22.days
      expect(entered_lead.overdue_by_twenty_one).to eq(true)
    end
    it 'returns true if the last note was 21 days in the past or more' do
      note.save
      expect(entered_lead.overdue_by_twenty_one).to eq(false)
      note.update created_at: Date.today - 21.days
      expect(entered_lead.overdue_by_twenty_one).to eq(false)
      note.update created_at: Date.today - 22.days
      expect(entered_lead.overdue_by_twenty_one).to eq(true)
    end
  end

  describe '.overdue_by_thirty_five' do
    it 'returns true if the follow up date is 10 days in the past if there are no notes' do
      expect(entered_lead.overdue_by_thirty_five).to eq(false)
      entered_lead.update follow_up_by: Date.today - 35.days
      expect(entered_lead.overdue_by_thirty_five).to eq(false)
      entered_lead.update follow_up_by: Date.today - 36.days
      expect(entered_lead.overdue_by_thirty_five).to eq(true)
    end
    it 'returns true if the last note was 35 days in the past or more' do
      note.save
      expect(entered_lead.overdue_by_thirty_five).to eq(false)
      note.update created_at: Date.today - 35.days
      expect(entered_lead.overdue_by_thirty_five).to eq(false)
      note.update created_at: Date.today - 36.days
      expect(entered_lead.overdue_by_thirty_five).to eq(true)
    end
  end

  describe '.comcast_old_lead_deactivate' do
    let!(:reason) { create :comcast_lead_dismissal_reason, name: '35 days without follow up' }
    let!(:admin) { create :person, email: 'retailingw@retaildoneright.com' }
    it 'deactivates leads that have been inactive for 35 days' do
      entered_lead.update follow_up_by: Date.today - 36.days
      expect(entered_lead.active).to eq(true)
      entered_lead.comcast_old_lead_deactivate
      entered_lead.reload
      expect(entered_lead.active).to eq(false)
      expect(entered_lead.comcast_customer.comcast_lead_dismissal_reason).to eq(reason)
      expect(entered_lead.comcast_customer.dismissal_comment).to eq('Auto-closed after 35 days of inactivity')
      expect(LogEntry.count).to eq(1)
    end
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
