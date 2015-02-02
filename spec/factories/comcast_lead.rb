FactoryGirl.define do

  factory :comcast_lead do
    comcast_customer
    tv true
    ok_to_call_and_text true
    active true
  end

end