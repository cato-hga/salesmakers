FactoryGirl.define do

  factory :area do
    name 'A Test Area'
    association :area_type
    association :project
  end
end