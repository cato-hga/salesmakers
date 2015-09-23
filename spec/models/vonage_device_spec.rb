require 'rails_helper'

describe VonageDevice do
  subject { build :vonage_device }

  it 'requires a PO Number to be present and 12 or 16 characters long' do
    subject.po_number = nil
    expect(subject).not_to be_valid
    subject.po_number = '1234567890'
    expect(subject).not_to be_valid
    subject.po_number = '123456789012'
    expect(subject).to be_valid
    subject.po_number = '1234567890123456'
    expect(subject).to be_valid
  end

  it 'requires a Mac Id to be present and can only be 12 characters long (A-F 0-9)' do
    subject.mac_id = nil
    expect(subject).not_to be_valid
    subject.mac_id = 'abzz12345678'
    expect(subject).not_to be_valid
    subject.mac_id = 'ab12345678901'
    expect(subject).not_to be_valid
    subject.mac_id = 'ab1234567890'
    expect(subject).to be_valid
  end

  it 'requires a receive date' do
    subject.receive_date = nil
    expect(subject).not_to be_valid
    subject.receive_date = Date.today
    expect(subject).to be_valid
  end
end
