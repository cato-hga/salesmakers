FactoryGirl.define do

  sequence :historical_sequential_email do |n|
    "tuser#{n}@rbd-von.com"
  end

  factory :historical_person do
    date { Date.today }
    first_name 'Test'
    last_name 'User'
    display_name 'Test User'
    email { generate(:historical_sequential_email) }
    mobile_phone '8005551001'
    association :position
    trait :mobile_two do
      mobile_phone '7274985180'
    end
  end
end