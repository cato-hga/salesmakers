# == Schema Information
#
# Table name: interview_answers
#
#  id                                     :integer          not null, primary key
#  work_history                           :text             not null
#  why_in_market                          :text
#  ideal_position                         :text
#  what_are_you_good_at                   :text
#  what_are_you_not_good_at               :text
#  compensation_last_job_one              :text
#  compensation_last_job_two              :text
#  compensation_last_job_three            :text
#  compensation_seeking                   :string           not null
#  hours_looking_to_work                  :text
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  candidate_id                           :integer
#  willingness_characteristic             :text             not null
#  personality_characteristic             :text             not null
#  self_motivated_characteristic          :text             not null
#  last_two_positions                     :text
#  what_interests_you                     :text             not null
#  first_thing_you_sold                   :text             not null
#  first_building_of_working_relationship :text             not null
#  first_rely_on_teaching                 :text             not null
#  availability_confirm                   :boolean          default(FALSE), not null
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
  has_many :log_entries, as: :trackable, dependent: :destroy

end
