FactoryGirl.define do

  factory :vonage_sale do
    sale_date Date.yesterday
    person
    confirmation_number 'ABCDE12345'
    location
    customer_first_name 'Johnny'
    customer_last_name 'Walker'
    mac '906EBB123456'
    vonage_product
    resold false
  end

end