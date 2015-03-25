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

  describe 'completion' do
    it 'shows as complete for passes or failures' do
      subject.sex_offender_check = 1
      subject.public_background_check = 1
      subject.private_background_check = 2
      subject.drug_screening = 2
      expect(subject.complete?).to be_truthy

      subject.sex_offender_check = 2
      subject.public_background_check = 2
      subject.private_background_check = 3
      subject.drug_screening = 3
      expect(subject.complete?).to be_truthy
    end

    it 'shows as incomplete when one portion is not done' do
      subject.sex_offender_check = 0
      subject.public_background_check = 1
      subject.private_background_check = 2
      subject.drug_screening = 2
      expect(subject.complete?).to be_falsey

      subject.sex_offender_check = 2
      subject.public_background_check = 0
      subject.private_background_check = 3
      subject.drug_screening = 3
      expect(subject.complete?).to be_falsey

      subject.sex_offender_check = 2
      subject.public_background_check = 2
      subject.private_background_check = 0
      subject.drug_screening = 3
      expect(subject.complete?).to be_falsey

      subject.sex_offender_check = 2
      subject.public_background_check = 2
      subject.private_background_check = 1
      subject.drug_screening = 3
      expect(subject.complete?).to be_falsey

      subject.sex_offender_check = 2
      subject.public_background_check = 2
      subject.private_background_check = 3
      subject.drug_screening = 0
      expect(subject.complete?).to be_falsey

      subject.sex_offender_check = 2
      subject.public_background_check = 2
      subject.private_background_check = 3
      subject.drug_screening = 1
      expect(subject.complete?).to be_falsey
    end

    it 'shows as partially complete with one pass/fail' do
      subject.sex_offender_check = 2
      expect(subject.partially_complete?).to be_truthy
    end

    it 'shows as not partially complete with none pass/fail' do
      subject.private_background_check = 1
      subject.drug_screening = 1
      expect(subject.partially_complete?).to be_falsey
    end
  end
end