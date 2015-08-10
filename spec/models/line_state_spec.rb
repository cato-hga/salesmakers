# == Schema Information
#
# Table name: line_states
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  locked     :boolean          default(FALSE)
#

require 'rails_helper'

describe LineState do

  subject { build :line_state }

  it 'is valid in its initial state' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name at least 3 characters long' do
    subject.name = 'ab'
    expect(subject).not_to be_valid
  end

  it 'requires a unique name' do
    subject.save
    new_line_state = build :line_state
    expect(new_line_state).not_to be_valid
  end

end
