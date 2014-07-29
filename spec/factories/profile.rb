FactoryGirl.define do

  factory :profile do
    association :person, strategy: :build
  end
end