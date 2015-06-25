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
  subject { build :directv_lead }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a directv_customer_id' do
    subject.directv_customer_id = nil
    expect(subject).not_to be_valid
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

  it 'reflects the DirecTVCustomer name as directv_customer_name' do
    expect(subject.directv_customer_name).to eq(subject.directv_customer.name)
  end

  it 'reflects the DirecTVCustomer mobile phone as directv_customer_mobile_phone' do
    expect(subject.directv_customer_mobile_phone).to eq(subject.directv_customer.mobile_phone)
  end

  it 'reflects the DirecTVCustomer other phone as directv_customer_other_phone' do
    expect(subject.directv_customer_other_phone).to eq(subject.directv_customer.other_phone)
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
