FactoryGirl.define do
  factory :training_time_slot do
    association :training_class_type
    association :person
    start_date DateTime.at_beginning_of_day + 11.hours
    end_date DateTime.at_beginning_of_day + 14.hours
    tuesday true
  end

end
