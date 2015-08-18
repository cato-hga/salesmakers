# == Schema Information
#
# Table name: vonage_account_status_changes
#
#  id                 :integer          not null, primary key
#  mac                :string           not null
#  account_start_date :date             not null
#  account_end_date   :date
#  status             :integer          not null
#  termination_reason :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

describe VonageAccountStatusChange do
  subject { build :vonage_account_status_change }

  it 'requires the account start date not be in the future' do
    @time_now = Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)
    allow(Time).to receive(:now).and_return(@time_now)
    subject.account_start_date = Date.tomorrow
    expect(subject).not_to be_valid
  end

  it 'detects whether a status change matches the latest on record for the MAC' do
    subject.save
    status = build :vonage_account_status_change
    expect(status.matches_latest?).to be_truthy
    status.status = :terminated
    expect(status.matches_latest?).to be_falsey
  end
end
