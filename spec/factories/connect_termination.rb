FactoryGirl.define do

  factory :connect_termination do
    skip_create

    connect_user
    last_day_worked Date.today
  end
end