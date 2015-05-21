require 'rails_helper'

describe DirecTVCustomerNote do
  subject { build :directv_customer_note }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a directv_customer' do
    subject.directv_customer = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a note at least 5 characters long' do
    subject.note = 'a'*4
    expect(subject).not_to be_valid
  end
end