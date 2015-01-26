FactoryGirl.define do

  factory :comcast_sale do
    sale_date Date.today
    person
    comcast_customer
    order_number '1234567890'
    tv true
  end
end