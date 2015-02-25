FactoryGirl.define do

  factory :line do
    sequence(:identifier, (1..9).cycle) { |n| "727498518#{n}" }
    technology_service_provider
    contract_end_date Date.today + 3.months
  end
end