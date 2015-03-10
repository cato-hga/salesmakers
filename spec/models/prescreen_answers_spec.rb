require 'rails_helper'

describe PrescreenAnswer do

  let(:answer) { build :prescreen_answer }
  describe 'validations' do
    it 'requires a candidate' do
      answer.candidate_id = nil
      expect(answer).not_to be_valid
    end
    it 'requires an answer to all questions' do
      answer.worked_for_salesmakers = nil
      expect(answer).not_to be_valid
      answer.of_age_to_work = nil
      expect(answer).not_to be_valid
      answer.eligible_smart_phone = nil
      expect(answer).not_to be_valid
      answer.can_work_weekends = nil
      expect(answer).not_to be_valid
      answer.reliable_transportation = nil
      expect(answer).not_to be_valid
      answer.access_to_computer = nil
      expect(answer).not_to be_valid
      answer.part_time_employment = nil
      expect(answer).not_to be_valid
      answer.ok_to_screen = nil
      expect(answer).not_to be_valid
    end
  end
end