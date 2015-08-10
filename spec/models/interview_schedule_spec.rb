# == Schema Information
#
# Table name: interview_schedules
#
#  id             :integer          not null, primary key
#  candidate_id   :integer          not null
#  person_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  interview_date :date
#  start_time     :datetime         not null
#  active         :boolean
#

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
    it 'requires an interview date' do
      interview.interview_date = nil
      expect(interview).not_to be_valid
    end
  end
end
