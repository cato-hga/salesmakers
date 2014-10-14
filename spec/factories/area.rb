FactoryGirl.define do

  factory :area do
    name 'A Test Area'
    association :area_type, strategy: :build_stubbed
    association :project, strategy: :build_stubbed
  end
end