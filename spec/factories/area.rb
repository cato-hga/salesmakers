FactoryGirl.define do

  sequence :area_name do |n|
    "A Test Area #{n.to_s}"
  end

  factory :area do
    name { generate :area_name }
    active true
    association :area_type
    association :project
  end
end