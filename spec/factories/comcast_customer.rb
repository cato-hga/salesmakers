FactoryGirl.define do

  factory :comcast_customer do
    first_name 'Blanche'
    last_name 'Devereaux'
    sequence(:mobile_phone, (1..9).cycle) { |n| "800555100#{n}" }
    person
    location
  end

end