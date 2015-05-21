FactoryGirl.define do

  factory :directv_manager, class: Person do
    first_name 'DirecTv'
    last_name 'Manager'
    email 'directv_manager@dtv.salesmakersinc.com'
    mobile_phone '7274872610'
    association :position, factory: :directv_sales_manager_position, strategy: :build_stubbed
  end

  factory :directv_sales_manager_position, class: Position do
    name 'DirecTv Retail Territory Leader'
    leadership true
    all_field_visibility false
    all_corporate_visibility false
    association :department, factory: :directv_retail_department, strategy: :build_stubbed
    field true
    hq false
  end
end