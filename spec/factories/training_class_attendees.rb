FactoryGirl.define do
  factory :training_class_attendee do
    association :person
    association :training_class
  end
end
