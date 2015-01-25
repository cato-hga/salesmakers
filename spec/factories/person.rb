FactoryGirl.define do

  sequence :email do |n|
    "tuser#{n}@rbd-von.com"
  end

  factory :person do
    first_name 'Test'
    last_name 'User'
    email
    mobile_phone '7274872633'
    association :position
    trait :mobile_two do
      mobile_phone '7274872634'
    end
  end
end