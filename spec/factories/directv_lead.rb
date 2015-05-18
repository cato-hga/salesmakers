FactoryGirl.define do

  factory :directv_lead do
    directv_customer
    ok_to_call_and_text true
    active true
  end
end