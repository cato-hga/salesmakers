FactoryGirl.define do
  factory :vonage_transfer do
    to_person
    to_from
    vonage_device_id
    transfer_time Date.today

  end
end