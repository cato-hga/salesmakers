FactoryGirl.define do
  factory :comcast_eod do
    eod_date DateTime.now
    location
    sales_pro_visit false
    comcast_visit false
    cloud_training false
  end
end
