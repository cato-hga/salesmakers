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

  it 'saves with all necessary fields' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires line 1' do
    subject.line_1 = nil
    expect(subject).not_to be_valid
  end

  it 'requires that line 1 start with a number' do
    subject.line_1 = 'aa 2nd Ave NE'
    expect(subject).not_to be_valid
  end

  it 'requires a city' do
    subject.city = nil
    expect(subject).not_to be_valid
  end

  it 'requires the city be at least 2 characters long' do
    subject.city = 'a'
    expect(subject).not_to be_valid
  end

  it 'requires a state 2 characters long' do
    subject.state = nil
    expect(subject).not_to be_valid
    subject.state = 'a'
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

  it 'requires a ZIP' do
    subject.zip = nil
    expect(subject).not_to be_valid
  end

  it 'requires a ZIP 5 characters long' do
    subject.zip = '1234'
    expect(subject).not_to be_valid
  end

  it 'requires the ZIP be all numbers' do
    subject.zip = 'a1234'
    expect(subject).not_to be_valid
  end
end
