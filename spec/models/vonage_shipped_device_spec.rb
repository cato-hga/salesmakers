require 'rails_helper'

describe VonageShippedDevice do
  subject { build :vonage_shipped_device }

  it 'requires MAC ID have a valid format' do
    subject.mac = '906EBB12345'
    expect(subject).not_to be_valid
    subject.mac = '906EBB12345G'
    expect(subject).not_to be_valid
    subject.mac = '906ebb123456'
    expect(subject).to be_valid
  end

  it 'upcases MAC IDs' do
    subject.mac = '906ebb123456'
    expect(subject).to be_valid
    expect(subject.mac).to eq('906EBB123456')
  end
end