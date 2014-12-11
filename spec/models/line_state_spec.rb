require 'rails_helper'

describe LineState do

  subject { build :line_state }

  it 'is valid in its initial state' do
    expect(subject).to be_valid
  end

  it 'requires a name at least 5 characters long' do
    subject.name = nil
    expect(subject).not_to be_valid
    subject.name = 'abcd'
    expect(subject).not_to be_valid
  end

end
