FactoryGirl.define do

  factory :project do
    name 'Test Project'
    client strategy: :build_stubbed
  end
end
