FactoryGirl.define do

  sequence :email do |n|
    "tuser#{n}@rbd-von.com"
  end

  factory :person do
    first_name 'Test'
    last_name 'User'
    email
    mobile_phone '5551234567'
    association :position
  end
end