FactoryGirl.define do
  factory :vonage_transfer do
    association :to_person, factory: :person
    association :from_person, factory: :person
    vonage_device
    transfer_time Date.today
  end
end