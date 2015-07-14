FactoryGirl.define do

  factory :client_area_type do
    name 'Test Client Area Type'
    association :project, strategy: :build_stubbed
  end
end