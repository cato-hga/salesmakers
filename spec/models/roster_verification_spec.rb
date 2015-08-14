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
end
