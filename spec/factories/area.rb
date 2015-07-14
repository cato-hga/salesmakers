FactoryGirl.define do

  factory :area do
    name 'A Test Area'
    active true
    association :area_type
    association :project
  end
end