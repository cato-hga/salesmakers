# == Schema Information
#
# Table name: area_candidate_sourcing_groups
#
#  id           :integer          not null, primary key
#  group_number :integer
#  project_id   :integer          not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
