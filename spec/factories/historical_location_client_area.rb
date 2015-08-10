FactoryGirl.define do

  factory :historical_location_client_area do
    date { Date.today }
    historical_location
    historical_client_area
  end

end