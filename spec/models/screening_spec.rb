# == Schema Information
#
# Table name: screenings
#
#  id                       :integer          not null, primary key
#  person_id                :integer          not null
#  sex_offender_check       :integer          default(0), not null
#  public_background_check  :integer          default(0), not null
#  private_background_check :integer          default(0), not null
#  drug_screening           :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'rails_helper'

describe Screening do
  subject { build :screening }

  describe 'completion' do
    let(:person) { create :person }
    let(:screening) { create :screening, person: person }
    let!(:candidate) { create :candidate, person: person }

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

    it 'sets NOS status to a candidate that has a failed screening' do
      screening.sex_offender_check = 1
      screening.public_background_check = 2
      screening.private_background_check = 3
      screening.drug_screening = 3
      screening.save
      candidate.reload
      expect(candidate.training_session_status).to eq('nos')
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
