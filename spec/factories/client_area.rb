FactoryGirl.define do

  factory :client_area do
    name 'A Test Client Area'
    association :client_area_type
    association :project
  end

end