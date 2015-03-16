FactoryGirl.define do

  factory :interview_schedule do
    association :candidate
    association :person
    start_time Time.zone.now
    interview_date Date.today
    active true
  end
end