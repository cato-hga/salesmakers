FactoryGirl.define do

  factory :communication_log_entry do
    association :loggable, factory: :sms_message
    person
  end

end