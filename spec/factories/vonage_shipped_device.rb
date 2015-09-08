FactoryGirl.define do

  factory :vonage_shipped_device do
    active true
    po_number '2015892'
    ship_date { Date.yesterday }
    mac '906EBB123456'
  end

end