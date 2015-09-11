FactoryGirl.define do
  factory :vonage_transfer do
    to_person_id 1234
    from_person_id 5678
    vonage_device
    transfer_time Date.today
  end
end