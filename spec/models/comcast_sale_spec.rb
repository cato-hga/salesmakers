require 'rails_helper'

describe ComcastSale do
  subject { build :comcast_sale }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires at least one of tv, internet, phone, or security' do
    subject.tv = false
    subject.internet = false
    subject.security = false
    subject.phone = false
    expect(subject).not_to be_valid
    subject.tv = true
    expect(subject).to be_valid
    subject.tv = false; subject.internet = true
    expect(subject).to be_valid
    subject.internet = false; subject.security = true
    expect(subject).to be_valid
    subject.security = false; subject.phone = true
    expect(subject).to be_valid
  end
end