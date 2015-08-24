# == Schema Information
#
# Table name: candidate_contacts
#
#  id             :integer          not null, primary key
#  contact_method :integer          not null
#  inbound        :boolean          default(FALSE), not null
#  person_id      :integer          not null
#  candidate_id   :integer          not null
#  notes          :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  call_results   :text
#

require 'rails_helper'

describe CandidateContact do
  subject { build :candidate_contact }

  it 'requires that the contact method be valid' do
    expect {
      subject.contact_method = 77
    }.to raise_error(ArgumentError)
  end
end
