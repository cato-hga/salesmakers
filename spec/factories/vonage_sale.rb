FactoryGirl.define do

  sequence :mac do |n|
    "906EBB123#{n.to_s.rjust(3, '0')}"
  end

  factory :vonage_sale do
    sale_date Date.yesterday
    person
    confirmation_number 'ABCDE12345'
    location
    customer_first_name 'Johnny'
    customer_last_name 'Walker'
    mac { generate :mac }
    vonage_product
    person_acknowledged true
    gift_card_number 'ab1234567890'
    resold false
    association :creator, factory: :person
  end

end