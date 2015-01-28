FactoryGirl.define do

  factory :comcast_sale do
    sale_date Date.today
    person
    comcast_customer
    order_number '1234567890'
    tv true

    after(:build) do |comcast_sale|
      comcast_sale.comcast_install_appointment ||= build(:comcast_install_appointment,
                                                 comcast_sale: comcast_sale)
    end
  end
end