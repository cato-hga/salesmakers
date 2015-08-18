# == Schema Information
#
# Table name: person_addresses
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  line_1     :string           not null
#  line_2     :string
#  city       :string           not null
#  state      :string           not null
#  zip        :string           not null
#  physical   :boolean          default(TRUE), not null
#  created_at :datetime
#  updated_at :datetime
#  latitude   :float
#  longitude  :float
#  time_zone  :string
#

require 'rails_helper'

describe PersonAddress do
  subject { build :person_address }

  it 'requires that line 1 start with a number' do
    subject.line_1 = 'aa 2nd Ave NE'
    expect(subject).not_to be_valid
  end

  it 'requires the state to be valid' do
    subject.state = 'CC'
    expect(subject).not_to be_valid
  end

  it 'changes the state to uppercase' do
    subject.state = 'ca'
    expect(subject.state).to eq('CA')
    expect(subject).to be_valid
  end

  it 'requires the ZIP be all numbers' do
    subject.zip = 'a1234'
    expect(subject).not_to be_valid
  end
end
