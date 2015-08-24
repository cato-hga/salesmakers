FactoryGirl.define do
  factory :vonage_device do
    po_number 'abcdefgh1234'
    sequence(:mac_id, (1..9).cycle) { |n| "#{n}23456789abc" }
    person
    receive_date Date.today
  end
end