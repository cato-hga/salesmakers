FactoryGirl.define do
  factory :training_class do
    association :training_class_type
    association :training_time_slot
    association :person
    date DateTime.new(2015, Date.today.month, Date.today.day, 12, 0, 0)
  end
end
