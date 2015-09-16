FactoryGirl.define do
  sequence :meid do
    rand(10**18).to_s.rjust(18, '0')
  end

  sequence :mobile_phone do
    rand(10**10).to_s.rjust(10, '0')
  end

  factory :sprint_sale do
    sale_date Date.yesterday
    person
    location
    meid { generate :meid }
    mobile_phone { generate :mobile_phone }
    sprint_carrier
    sprint_handset
    upgrade false
    sprint_rate_plan
    top_up_card_purchased false
    phone_activated_in_store true
    number_of_accessories 1
    picture_with_customer 'No, Forgot'
    association :project
  end
end