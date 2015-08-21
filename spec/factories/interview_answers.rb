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
