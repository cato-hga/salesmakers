hvogFactoryGirl.define do

  factory :device do
    sequence(:identifier, (1..9).cycle) { |n| "12345#{n}" }
    sequence(:serial) { |n| "A5669151360893556#{n}" }
    device_model
  end
end
