FactoryGirl.define do

  factory :shift do
    person
    date Date.yesterday
    hours 7.6
  end

end