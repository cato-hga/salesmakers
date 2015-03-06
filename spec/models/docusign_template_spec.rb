require 'rails_helper'

describe DocusignTemplate do
  subject { build :docusign_template }

  it 'is correct with valid attributes' do
    expect(subject).to be_valid
  end

  it 'requires a template_guid' do
    subject.template_guid = nil
    expect(subject).not_to be_nil
  end

  it 'requires a state' do
    subject.state = nil
    expect(subject).not_to be_valid
  end

  it 'requires the state be valid' do
    subject.state = 'NB'
    expect(subject).not_to be_valid
  end

  it 'requires a document_type' do
    subject.document_type = nil
    expect(subject).not_to be_valid
  end
end