# == Schema Information
#
# Table name: interview_answers
#
#  id                            :integer          not null, primary key
#  work_history                  :text             not null
#  why_in_market                 :text             not null
#  ideal_position                :text             not null
#  what_are_you_good_at          :text             not null
#  what_are_you_not_good_at      :text             not null
#  compensation_last_job_one     :string           not null
#  compensation_last_job_two     :string
#  compensation_last_job_three   :string
#  compensation_seeking          :string           not null
#  hours_looking_to_work         :string           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  candidate_id                  :integer
#  willingness_characteristic    :text             not null
#  personality_characteristic    :text             not null
#  self_motivated_characteristic :text             not null
#  last_two_positions            :text             not null
#

class InterviewAnswer < ActiveRecord::Base
  validates :work_history, presence: true
  validates :why_in_market, presence: true
  validates :ideal_position, presence: true
  validates :what_are_you_good_at, presence: true
  validates :what_are_you_not_good_at, presence: true
  validates :compensation_last_job_one, presence: true
  validates :compensation_seeking, presence: true
  validates :hours_looking_to_work, presence: true
  validates :personality_characteristic, presence: true
  validates :self_motivated_characteristic, presence: true
  validates :willingness_characteristic, presence: true
  belongs_to :candidate
  accepts_nested_attributes_for :candidate
end
