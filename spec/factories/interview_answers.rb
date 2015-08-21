# == Schema Information
#
# Table name interview_answers
#
#  id                            integer          not null primary key
#  work_history                  text             not null
#  why_in_market                 text             not null
#  ideal_position                text             not null
#  what_are_you_good_at          text             not null
#  what_are_you_not_good_at      text             not null
#  compensation_last_job_one     string           not null
#  compensation_last_job_two     string
#  compensation_last_job_three   string
#  compensation_seeking          string           not null
#  hours_looking_to_work         string           not null
#  created_at                    datetime         not null
#  updated_at                    datetime         not null
#  candidate_id                  integer
#  willingness_characteristic    text             not null
#  personality_characteristic    text             not null
#  self_motivated_characteristic text             not null
#  last_two_positions            text             not null
#

FactoryGirl.define do
  factory :interview_answer do
    work_history 'Work History'
    what_interests_you 'What interests you'
    first_thing_you_sold 'first_thing_you_sold'
    first_building_of_working_relationship 'first_building_of_working_relationship'
    first_rely_on_teaching 'first_rely_on_teaching'
    willingness_characteristic 'Willing'
    personality_characteristic 'Willing'
    self_motivated_characteristic 'Willing'
    compensation_seeking 'Seeking comp'
    availability_confirm true
    association :candidate
  end
end
