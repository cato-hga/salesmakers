FactoryGirl.define do

  factory :connect_timesheet do
    skip_create

    shift_date Date.yesterday
    hours Random.new.rand * (9-2) + 2
  end

end