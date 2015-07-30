# == Schema Information
#
# Table name: roster_verifications
#
#  id                             :integer          not null, primary key
#  creator_id                     :integer          not null
#  person_id                      :integer          not null
#  status                         :integer          default(0), not null
#  last_shift_date                :date
#  location_id                    :integer
#  envelope_guid                  :string
#  roster_verification_session_id :integer          not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  issue                          :string
#

require 'rails_helper'

describe RosterVerification do
  subject { build :roster_verification }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a creator' do
    subject.creator = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a status' do
    subject.status = nil
    expect(subject).not_to be_valid
  end

  it 'responds to last_shift_date' do
    expect(subject).to respond_to :last_shift_date
  end

  it 'responds to location' do
    expect(subject).to respond_to :location
  end

  it 'responds to envelope_guid' do
    expect(subject).to respond_to :envelope_guid
  end

  it 'responds to issue' do
    expect(subject).to respond_to :issue
  end

  it 'requires an issue if the status is "issue"' do
    subject.status = RosterVerification.statuses[:issue]
    expect(subject).not_to be_valid
    subject.issue = 'This is a big issue'
    expect(subject).to be_valid
  end

  it 'requires a roster verification session' do
    subject.roster_verification_session = nil
    expect(subject).not_to be_valid
  end
end