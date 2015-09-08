FactoryGirl.define do

  sequence :override_card_number do |n|
    "98765432101234#{n.to_s.rjust(2, '0')}"
  end

  factory :gift_card_override do
    association :creator, factory: :person
    person
    original_card_number '1234567890123456'
    override_card_number { generate(:override_card_number) }
  end

end