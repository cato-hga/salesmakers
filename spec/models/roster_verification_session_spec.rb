# == Schema Information
#
# Table name: roster_verification_sessions
#
#  id                :integer          not null, primary key
#  creator_id        :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  missing_employees :string
#

require 'rails_helper'

describe RosterVerificationSession do
  subject { build :roster_verification_session }

  it 'responds to missing_employees' do
    expect(subject).to respond_to :missing_employees
  end
end
