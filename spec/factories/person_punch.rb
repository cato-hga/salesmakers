FactoryGirl.define do

  factory :person_punch do
    identifier 'bob1234'
    punch_time { DateTime.now - 2.minutes }
    in_or_out 0
  end

end