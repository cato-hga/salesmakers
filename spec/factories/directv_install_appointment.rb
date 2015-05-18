FactoryGirl.define do

  factory :directv_install_appointment do
    directv_sale
    directv_install_time_slot
    install_date Date.tomorrow
  end

end