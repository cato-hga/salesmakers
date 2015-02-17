FactoryGirl.define do

  factory :vonage_sale_payout do
    vonage_sale
    person
    payout 10.00
    vonage_paycheck
  end

end