FactoryGirl.define do

  factory :prescreen_answer do
    association :candidate
    worked_for_salesmakers true
    of_age_to_work true
    eligible_smart_phone true
    can_work_weekends true
    reliable_transportation true
    access_to_computer true
    part_time_employment true
    ok_to_screen true
  end
end