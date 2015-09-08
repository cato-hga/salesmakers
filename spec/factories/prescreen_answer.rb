FactoryGirl.define do

  factory :prescreen_answer do
    association :candidate
    worked_for_salesmakers true
    of_age_to_work true
    eligible_smart_phone true
    can_work_weekends true
    reliable_transportation true
    worked_for_sprint true
    high_school_diploma true
    ok_to_screen true
    visible_tattoos true
    has_sales_experience true
    sales_experience_notes 'Test Notes'
  end
end