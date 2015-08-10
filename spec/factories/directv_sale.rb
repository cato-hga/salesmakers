FactoryGirl.define do

  factory :directv_sale do
    order_date Date.today
    person
    directv_customer
    sequence(:order_number, (10..99).cycle) { |n| "12345678910#{n}" }

    after(:build) do |directv_sale|
      directv_sale.directv_install_appointment ||= build(:directv_install_appointment,
                                                         directv_sale: directv_sale)
    end
  end

  factory :directv_former_provider do
    name 'Former Provider'
  end
end