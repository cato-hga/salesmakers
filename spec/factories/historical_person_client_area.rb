FactoryGirl.define do

  factory :historical_person_client_area do
    date { Date.today }
    historical_person
    historical_client_area
  end
end
