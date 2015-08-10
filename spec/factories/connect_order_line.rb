FactoryGirl.define do

  factory :connect_order_line do
    description 'ABCDE12345'
    connect_product
  end

end