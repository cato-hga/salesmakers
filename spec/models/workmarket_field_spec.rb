# == Schema Information
#
# Table name: workmarket_fields
#
#  id                       :integer          not null, primary key
#  workmarket_assignment_id :integer          not null
#  name                     :string           not null
#  value                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'rails_helper'

describe WorkmarketField do
  subject { build :workmarket_field }

  it 'requires a workmarket_assigment' do
    subject.workmarket_assignment = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a value' do
    subject.value = nil
    expect(subject).not_to be_valid
  end
end
