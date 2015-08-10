FactoryGirl.define do

  factory :device_deployment do
    device
    person
    started Date.today
  end
end