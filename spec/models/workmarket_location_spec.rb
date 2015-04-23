require 'rails_helper'

describe WorkmarketLocation do
  subject { build :workmarket_location }

  it 'requires a workmarket_location_num' do
    subject.workmarket_location_num = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'responds to location_number' do
    expect(subject).to respond_to(:location_number)
  end
end