require 'rails_helper'

describe RingCentralCallLogger, :vcr do
  subject { described_class.log }

  it 'saves call logs' do
    expect { subject }.to change(RingCentralCall, :count).by_at_least 1
  end
end