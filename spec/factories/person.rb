FactoryGirl.define do

  sequence :email do |n|
    "tuser#{n}@rbd-von.com"
  end

  factory :person do
    first_name 'Test'
    last_name 'User'
    email
    mobile_phone '8635214572'
    association :position
  end
end