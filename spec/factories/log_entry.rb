FactoryGirl.define do

  factory :log_entry do
    person
    action 'create'
    trackable { build :device }
  end
end