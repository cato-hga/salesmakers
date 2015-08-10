FactoryGirl.define do

  factory :person_pay_rate do
    person
    wage_type :hourly
    rate 10.00
    effective_date { Date.today - 2.weeks }
  end

end