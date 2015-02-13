FactoryGirl.define do

  factory :comcast_manager, class: Person do
    first_name 'Comcast'
    last_name 'Manager'
    email 'comcast_manager@cc.salesmakersinc.com'
    mobile_phone '7274872610'
    association :position, factory: :comcast_sales_manager_position, strategy: :build_stubbed
  end

  factory :comcast_sales_manager_position, class: Position do
    name 'Comcast Retail Territory Leader'
    leadership true
    all_field_visibility false
    all_corporate_visibility false
    association :department, factory: :comcast_retail_department, strategy: :build_stubbed
    field true
    hq false
  end
end