FactoryGirl.define do

  factory :connect_order do
    skip_create

    created { Time.now }
    updated { Time.now }
    documentno 'VON906EBB123456+'
    dateordered { Time.now - 1.day }
    connect_business_partner
    connect_business_partner_location
    createdby '337EB300331F4762A4200CDE357E79E6'
  end

end