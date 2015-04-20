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