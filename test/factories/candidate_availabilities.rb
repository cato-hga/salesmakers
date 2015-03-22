FactoryGirl.define do
  factory :candidate_availability do
    association :candidate
    monday_first true
  end

end
