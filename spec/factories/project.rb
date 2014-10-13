FactoryGirl.define do

  factory :project do
    name 'Test Project'
    association :client, strategy: :build_stubbed
  end
end
