class InterviewSchedule < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :person_id, presence: true
  validates :start_time, presence: true
  validates :interview_date, presence: true

  belongs_to :candidate
  belongs_to :person

  default_scope { joins(:person).order('people.display_name') }
end
