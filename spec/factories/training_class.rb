FactoryGirl.define do
  factory :training_class do
    association :training_class_type
    association :training_time_slot
    association :person
    date DateTime.today
  end
end
