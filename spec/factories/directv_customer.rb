FactoryGirl.define do

  factory :directv_customer do
    first_name 'Comcast'
    last_name 'Customer'
    sequence(:mobile_phone, (1..9).cycle) { |n| "727498518#{n}" }
    person
    location
  end

end