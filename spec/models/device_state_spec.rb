require 'rails_helper'

describe DeviceState do

  subject { build :device_state }

  it 'is valid in its initial state' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name at least 5 characters long' do
    subject.name = 'abcd'
    expect(subject).not_to be_valid
  end

  it 'requires a unique name' do
    subject.save
    new_device_state = build :device_state
    expect(new_device_state).not_to be_valid
  end

end
