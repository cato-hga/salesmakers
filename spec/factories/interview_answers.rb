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

FactoryGirl.define do
  factory :interview_answer do
    work_history 'Work History'
    why_in_market 'Why In Market'
    last_two_positions 'Last two Positions'
    ideal_position 'Ideal Position'
    what_are_you_good_at 'Good at'
    what_are_you_not_good_at 'Not good at'
    compensation_last_job_one 'Last job one'
    compensation_seeking 'Seeking'
    hours_looking_to_work 'Looking to work'
    willingness_characteristic 'Characteristic'
    self_motivated_characteristic 'Characteristic'
    personality_characteristic 'Characteristic'
    association :candidate
  end
end
