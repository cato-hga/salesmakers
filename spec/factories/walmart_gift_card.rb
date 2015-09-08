FactoryGirl.define do

  sequence :gift_card_number do |n|
    "12345678901234#{n.to_s.rjust(2, '0')}"
  end

  factory :walmart_gift_card do
    used false
    card_number { generate :gift_card_number }
    challenge_code 'hfg8uet'
    link 'https://egiftcard.walmart.com/blahblah'
    pin '4567'
    balance 60.00
    overridden false
  end

end