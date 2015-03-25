require 'rails_helper'

describe Screening do
  subject { build :screening }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a sex offender check' do
    subject.sex_offender_check = nil
    expect(subject).not_to be_valid
  end

  it 'requires a public background check' do
    subject.public_background_check = nil
    expect(subject).not_to be_valid
  end

  it 'requires a private background check' do
    subject.private_background_check = nil
    expect(subject).not_to be_valid
  end

  it 'requires a drug screening' do
    subject.drug_screening = nil
    expect(subject).not_to be_valid
  end
end