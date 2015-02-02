FactoryGirl.define do

  factory :comcast_install_appointment do
    comcast_sale
    comcast_install_time_slot
    install_date Date.tomorrow
  end

end