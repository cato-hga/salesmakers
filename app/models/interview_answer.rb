class InterviewAnswer < ActiveRecord::Base
  validates :work_history, presence: true
  validates :why_in_market, presence: true
  validates :ideal_position, presence: true
  validates :what_are_you_good_at, presence: true
  validates :what_are_you_not_good_at, presence: true
  validates :compensation_last_job_one, presence: true
  validates :compensation_seeking, presence: true
  validates :hours_looking_to_work, presence: true
  belongs_to :candidate
  accepts_nested_attributes_for :candidate
end
