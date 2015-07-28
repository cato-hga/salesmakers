FactoryGirl.define do

  factory :historical_area do
    date { Date.today }
    name 'A Test Area'
    active true
    association :area_type
    association :project
  end

end