FactoryGirl.define do

  factory :sms_daily_check do
    association :person
    association :sms, factory: :person
    date Date.today
  end

end