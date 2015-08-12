FactoryGirl.define do

  factory :connect_order do
    skip_create

    created { Time.now }
    updated { Time.now }
    documentno 'VON906EBB123456+'
    dateordered { Time.now - 1.day }
    connect_business_partner
    connect_business_partner_location
  end

end