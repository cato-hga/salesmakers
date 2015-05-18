FactoryGirl.define do

  factory :directv_employee, class: Person do
    first_name 'DirecTV'
    last_name 'Employee'
    email 'directv_employee@dtv.salesmakersinc.com'
    mobile_phone '7274872610'
    association :position, factory: :directv_sales_position
  end

  factory :directv_sales_position, class: Position do
    name 'DirecTV Retail Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    association :department, factory: :directv_retail_department
    field true
    hq false
  end

  factory :directv_retail_department, class: Department do
    name 'DirecTV Retail Sales'
    corporate false
  end
end