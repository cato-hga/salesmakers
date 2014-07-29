FactoryGirl.define do

  factory :log_entry do
    association :person, strategy: :build
    action 'create'
    trackable { build :device }
  end
end