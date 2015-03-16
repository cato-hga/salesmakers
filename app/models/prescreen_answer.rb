class PrescreenAnswer < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :worked_for_salesmakers, presence: true
  validates :of_age_to_work, presence: true
  validates :eligible_smart_phone, presence: true
  validates :can_work_weekends, presence: true
  validates :reliable_transportation, presence: true
  validates :worked_for_sprint, presence: true
  validates :high_school_diploma, presence: true

  belongs_to :candidate
end