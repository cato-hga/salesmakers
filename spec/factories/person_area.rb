FactoryGirl.define do

  factory :person_area do
    person strategy: :build_stubbed
    area strategy: :build_stubbed
    manages false
  end
end
