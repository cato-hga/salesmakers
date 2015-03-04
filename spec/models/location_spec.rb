require 'rails_helper'

describe Location do
  subject { build :location }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a store_number' do
    subject.store_number = nil
    expect(subject).not_to be_valid
  end

  it 'requires a city' do
    subject.city = nil
    expect(subject).not_to be_valid
  end

  it 'requires a city at least 2 characters long' do
    subject.city = 'a'
    expect(subject).not_to be_valid
  end

  it 'requires a state' do
    subject.state = nil
    expect(subject).not_to be_valid
  end

  it 'requires the state be valid' do
    subject.state = 'FF'
    expect(subject).not_to be_valid
  end

  it 'requires a channel' do
    subject.channel = nil
    expect(subject).not_to be_valid
  end

  it 'responds to latitude and longitude' do
    expect(subject).to respond_to(:latitude)
    expect(subject).to respond_to(:longitude)
  end
end