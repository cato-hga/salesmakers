FactoryGirl.define do

  factory :comcast_sale do
    order_date Date.today
    person
    comcast_customer
    sequence(:order_number, (10..99).cycle) { |n| "12345678910#{n}" }
    tv true

    after(:build) do |comcast_sale|
      comcast_sale.comcast_install_appointment ||= build(:comcast_install_appointment,
                                                 comcast_sale: comcast_sale)
    end
  end

  factory :comcast_former_provider do
    name 'Former Provider'
  end
end