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
