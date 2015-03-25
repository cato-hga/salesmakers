require 'rails_helper'

describe AreaCandidateSourcingGroup do
  subject { build :area_candidate_sourcing_group }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a project' do
    subject.project = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

end