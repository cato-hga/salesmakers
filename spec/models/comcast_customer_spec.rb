require 'rails_helper'

describe ComcastCustomer do
  subject { build :comcast_customer }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'returns a full name' do
    expect(subject.name).to eq(subject.first_name + ' ' + subject.last_name)
  end
end