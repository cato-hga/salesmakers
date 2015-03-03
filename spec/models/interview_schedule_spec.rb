require 'rails_helper'
describe InterviewSchedule do

  describe 'validations' do
    let(:interview) { build :interview_schedule }
    it 'requires a candidate' do
      interview.candidate_id = nil
      expect(interview).not_to be_valid
    end
    it 'requires a person' do
      interview.person_id = nil
      expect(interview).not_to be_valid
    end
    it 'requires a start time' do
      interview.start_time = nil
      expect(interview).not_to be_valid
    end
  end
end