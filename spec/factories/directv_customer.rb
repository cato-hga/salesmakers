FactoryGirl.define do

  factory :directv_customer do
    first_name 'DirecTV'
    last_name 'Customer'
    sequence(:mobile_phone, (1..9).cycle) { |n| "800555100#{n}" }
    person
    location
  end

end