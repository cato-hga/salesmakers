FactoryGirl.define do

  factory :vonage_manager, class: Person do
    first_name 'Vonage'
    last_name 'Manager'
    email 'vonage_manager@von.salesmakersinc.com'
    mobile_phone '8005551001'
    association :position, factory: :vonage_manager_position, strategy: :build_stubbed
  end

  factory :vonage_manager_position, class: Position do
    name 'Vonage Retail Territory Leader'
    leadership true
    all_field_visibility false
    all_corporate_visibility false
    association :department, factory: :vonage_retail_department, strategy: :build_stubbed
    field true
    hq false
  end
end