FactoryGirl.define do

  factory :historical_client_area do
    date { Date.today }
    name 'A Test Client Area'
    association :client_area_type
    association :project
  end

end