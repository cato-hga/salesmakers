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

class InterviewSchedule < ActiveRecord::Base
  validates :candidate_id, presence: true
  validates :person_id, presence: true
  validates :start_time, presence: true
  validates :interview_date, presence: true

  belongs_to :candidate
  belongs_to :person
  has_many :log_entries, as: :trackable, dependent: :destroy
  has_many :log_entries, as: :referenceable, dependent: :destroy

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
