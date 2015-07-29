FactoryGirl.define do

  factory :historical_location_area do
    date { Date.today }
    historical_location
    historical_area
  end

end