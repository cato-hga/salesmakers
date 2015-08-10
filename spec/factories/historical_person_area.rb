FactoryGirl.define do

  factory :historical_person_area do
    date { Date.today }
    historical_person
    historical_area
    manages false
  end
end
