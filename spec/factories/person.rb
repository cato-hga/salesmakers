FactoryGirl.define do

  sequence :last_name do |n|
    "User#{n.to_s}"
  end

  sequence :sequential_email do |n|
    "tuser#{n}@rbd-von.com"
  end

  factory :person do
    first_name 'Test'
    last_name { generate :last_name }
    email { generate(:sequential_email) }
    mobile_phone '8005551001'
    association :position
    trait :mobile_two do
      mobile_phone '7274985180'
    end
  end
end