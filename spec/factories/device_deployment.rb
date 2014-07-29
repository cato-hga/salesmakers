FactoryGirl.define do

  factory :device_deployment do
    device
    association :person, strategy: :build
    started Date.today - 2.months
  end
end