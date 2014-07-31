FactoryGirl.define do

  factory :line do
    identifier '7274985180'
    technology_service_provider
    contract_end_date Date.today + 3.months
  end
end