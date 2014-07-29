FactoryGirl.define do

  factory :person_area do
    association :person, strategy: :build
    area
    manages false
  end
end
