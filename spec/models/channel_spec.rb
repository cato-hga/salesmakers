require 'rails_helper'

describe Channel do
  subject { build :channel }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name at least 2 characters long' do
    subject.name = 'a'
    expect(subject).not_to be_valid
  end
end