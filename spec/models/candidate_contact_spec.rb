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

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a contact method' do
    subject.contact_method = nil
    expect(subject).not_to be_valid
  end

  it 'requires that the contact method be valid' do
    expect {
      subject.contact_method = 77
    }.to raise_error(ArgumentError)
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a candidate' do
    subject.candidate = nil
    expect(subject).not_to be_valid
  end

  it 'requires notes' do
    subject.notes = nil
    expect(subject).not_to be_valid
  end

  it 'requires notes at least 10 characters in length' do
    subject.notes = 'a'*9
    expect(subject).not_to be_valid
  end
end
