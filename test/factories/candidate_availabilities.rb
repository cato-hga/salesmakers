FactoryGirl.define do
  factory :candidate_availability do
    association :candidate
    monday_first true
    tuesday_second true
  end

end
