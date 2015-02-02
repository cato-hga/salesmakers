FactoryGirl.define do

  factory :comcast_lead do
    comcast_customer
    tv true
    active true
  end

end