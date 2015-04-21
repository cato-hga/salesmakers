require 'rails_helper'

describe WorkmarketAttachment do
  subject { build :workmarket_attachment }

  it 'requires a workmarket_assignment_id' do
    subject.workmarket_assignment_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a filename' do
    subject.filename = nil
    expect(subject).not_to be_valid
  end

  it 'requires a URL' do
    subject.url = nil
    expect(subject).not_to be_valid
  end

  it 'requires a guid' do
    subject.guid = nil
    expect(subject).not_to be_valid
  end
end