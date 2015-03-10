class PrescreenAnswer < ActiveRecord::Base

  validates :candidate_id, presence: true
  validates :worked_for_salesmakers, presence: true
  validates :of_age_to_work, presence: true
  validates :eligible_smart_phone, presence: true
  validates :can_work_weekends, presence: true
  validates :reliable_transportation, presence: true
  validates :access_to_computer, presence: true
  validates :part_time_employment, presence: true
  validates :ok_to_screen, presence: true

  belongs_to :candidate
end