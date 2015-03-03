FactoryGirl.define do

  factory :interview_schedule do
    association :candidate
    association :person
    start_time DateTime.now
  end
end