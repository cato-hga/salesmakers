# == Schema Information
#
# Table name: client_representatives
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe ClientRepresentative do
  subject { build :client_representative }

  it 'requires a client' do
    subject.client = nil
    expect(subject).not_to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires an email address' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it 'responds to permissions' do
    expect(subject).to respond_to(:permissions)
  end

  it 'validates that the email is unique' do
    subject.save
    expect(build(:client_representative)).not_to be_valid
  end

  it 'requires a password at least 6 characters long' do
    subject.password = 'a'*5
    expect(subject).not_to be_valid
  end
end
