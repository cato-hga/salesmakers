FactoryGirl.define do

  factory :sprint_sale do
    sale_date Date.yesterday
    person
    location
    meid '123456789012345678'
    mobile_phone '7274872633'
    carrier_name 'Boost Mobile'
    handset_model_name 'LG Volt'
    upgrade false
    rate_plan_name '$35/monthly'
    top_up_card_purchased false
    phone_activated_in_store true
    picture_with_customer 'No, Forgot'
  end

end