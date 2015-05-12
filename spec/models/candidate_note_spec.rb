require 'rails_helper'

describe CandidateNote do
  subject { build :candidate_note }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a candidate' do
    subject.candidate = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a note at least 5 characters long' do
    subject.note = 'a'*4
    expect(subject).not_to be_valid
  end
end