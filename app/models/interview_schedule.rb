class InterviewSchedule < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :person_id, presence: true
  validates :start_time, presence: true
  validates :interview_date, presence: true

  belongs_to :candidate
  belongs_to :person

  default_scope { joins(:person).order('people.display_name') }

  def self.cancel_all_interviews(candidate, person)
    active_interviews = candidate.interview_schedules.where(active: true)
    for interview in active_interviews do
      interview.update active: false
      person.log? 'cancel',
                  interview,
                  candidate
    end
  end
end
