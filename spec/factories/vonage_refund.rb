FactoryGirl.define do

  factory :vonage_refund do
    vonage_sale
    vonage_account_status_change
    refund_date Date.yesterday
    person
  end
end