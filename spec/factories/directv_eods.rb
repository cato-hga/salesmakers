FactoryGirl.define do
  factory :directv_eod do
    person
    eod_date DateTime.now
    location
    sales_pro_visit false
    directv_visit false
    cloud_training false
  end
end
