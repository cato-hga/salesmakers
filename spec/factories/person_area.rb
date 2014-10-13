FactoryGirl.define do

  factory :person_area do
    association :person, strategy: :build_stubbed
    association :area, strategy: :build_stubbed
    manages false
  end
end
