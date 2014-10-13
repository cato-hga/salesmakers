FactoryGirl.define do

  factory :area_type do
    name 'Test Area Type'
    association :project, strategy: :build_stubbed
  end
end