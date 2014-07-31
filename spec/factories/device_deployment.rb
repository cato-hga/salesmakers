FactoryGirl.define do

  factory :device_deployment do
    device
    person
    started Date.today - 2.months
  end
end