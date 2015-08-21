FactoryGirl.define do

  factory :walmart_gift_card do
    used false
    card_number '1234567890123456'
    challenge_code 'hfg8uet'
    link 'https://egiftcard.walmart.com/blahblah'
    pin '4567'
    balance 60.00
    overridden false
  end

end