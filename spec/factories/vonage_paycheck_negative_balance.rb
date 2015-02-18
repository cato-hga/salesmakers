FactoryGirl.define do

  factory :vonage_paycheck_negative_balance do
    person
    balance -50.00
    vonage_paycheck
  end

end