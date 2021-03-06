# == Schema Information
#
# Table name: directv_leads
#
#  id                  :integer          not null, primary key
#  active              :boolean          default(TRUE), not null
#  directv_customer_id :integer          not null
#  comments            :text
#  follow_up_by        :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ok_to_call_and_text :boolean
#

require 'rails_helper'

RSpec.describe DirecTVLead, :type => :model do
  let(:entered_lead) {
    lead = build :directv_lead, follow_up_by: Date.yesterday
    lead.save validate: false
    lead
  }

  let(:note) { build :directv_customer_note, directv_customer: entered_lead.directv_customer }
  subject { build :directv_lead }


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

  it 'reflects the DirecTVCustomer name as directv_customer_name' do
    expect(subject.directv_customer_name).to eq(subject.directv_customer.name)
  end

  it 'reflects the DirecTVCustomer mobile phone as directv_customer_mobile_phone' do
    expect(subject.directv_customer_mobile_phone).to eq(subject.directv_customer.mobile_phone)
  end

  it 'reflects the DirecTVCustomer other phone as directv_customer_other_phone' do
    expect(subject.directv_customer_other_phone).to eq(subject.directv_customer.other_phone)
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

  describe '.directv_old_lead_deactivate' do
    let!(:reason) { create :directv_lead_dismissal_reason, name: '35 days without follow up' }
    let!(:admin) { create :person, email: 'retailingw@retaildoneright.com' }
    it 'deactivates leads that have been inactive for 35 days' do
      entered_lead.update follow_up_by: Date.today - 36.days
      expect(entered_lead.active).to eq(true)
      entered_lead.directv_old_lead_deactivate
      entered_lead.reload
      expect(entered_lead.active).to eq(false)
      expect(entered_lead.directv_customer.directv_lead_dismissal_reason).to eq(reason)
      expect(entered_lead.directv_customer.dismissal_comment).to eq('Auto-closed after 35 days of inactivity')
      expect(LogEntry.count).to eq(1)
    end
  end

  describe 'scopes' do
    let!(:overdue_lead) {
      lead = build :directv_lead, follow_up_by: Date.yesterday
      lead.save validate: false
      lead
    }
    let!(:upcoming_lead) { create :directv_lead, follow_up_by: Date.tomorrow }
    let!(:today_lead) {
      lead = build :directv_lead, follow_up_by: Date.today
      lead.save validate: false
      lead
    }
    let!(:later_lead) { create :directv_lead, follow_up_by: Date.today + 8.days }
    let!(:no_date_lead) { create :directv_lead, follow_up_by: nil }


    it 'scopes overdue leads' do
      overdue_leads = DirecTVLead.overdue
      expect(overdue_leads).to include(overdue_lead)
      expect(overdue_leads).not_to include(upcoming_lead)
      expect(overdue_leads).not_to include(today_lead)
      expect(overdue_leads).not_to include(later_lead)
      expect(overdue_leads).not_to include(no_date_lead)
    end

    specify 'overdue leads do not include inactives' do
      overdue_lead.active = false
      overdue_lead.save validate: false
      overdue_leads = DirecTVLead.overdue
      expect(overdue_leads).not_to include(overdue_lead)
    end

    it 'scopes upcoming leads to follow_up_by dates within 7 days' do
      upcoming_leads = DirecTVLead.upcoming
      expect(upcoming_leads).to include(upcoming_lead)
      expect(upcoming_leads).to include(today_lead)
      expect(upcoming_leads).not_to include(overdue_lead)
      expect(upcoming_leads).not_to include(later_lead)
      expect(upcoming_leads).not_to include(no_date_lead)
    end

    specify 'upcoming leads do not include inactives' do
      upcoming_lead.update active: false
      upcoming_leads = DirecTVLead.upcoming
      expect(upcoming_leads).not_to include(upcoming_lead)
    end

    it 'scopes later and no date leads together' do
      later_leads = DirecTVLead.not_upcoming_or_overdue
      expect(later_leads).to include(later_lead)
      expect(later_leads).to include(no_date_lead)
      expect(later_leads).not_to include(overdue_lead)
      expect(later_leads).not_to include(upcoming_lead)
      expect(later_leads).not_to include(today_lead)
    end

    specify 'not upcoming and not overdue do not include inactives' do
      no_date_lead.update active: false
      later_leads = DirecTVLead.not_upcoming_or_overdue
      expect(later_leads).not_to include(no_date_lead)
    end
  end
end
