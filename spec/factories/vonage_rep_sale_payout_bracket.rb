FactoryGirl.define do

  factory :vonage_rep_sale_payout_bracket do
    per_sale 15.00
    area
    sales_minimum 3
    sales_maximum 5
  end
end