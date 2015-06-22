require 'rails_helper'

describe SMSDailyCheck do

  let(:check) { create :sms_daily_check }

  it 'requires a person' do
    check.person_id = nil
    expect(check).not_to be_valid
  end

  it 'requires an SMS' do
    check.sms_id = nil
    expect(check).not_to be_valid
  end

  it 'requires a date' do
    check.date = nil
    expect(check).not_to be_valid
  end
end