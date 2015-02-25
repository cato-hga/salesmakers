FactoryGirl.define do

  factory :comcast_employee, class: Person do
    first_name 'Comcast'
    last_name 'Employee'
    email 'comcast_employee@cc.salesmakersinc.com'
    mobile_phone '7274872610'
    association :position, factory: :comcast_sales_position
  end

  factory :comcast_sales_position, class: Position do
    name 'Comcast Retail Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    association :department, factory: :comcast_retail_department
    field true
    hq false
  end

  factory :comcast_retail_department, class: Department do
    name 'Comcast Retail Sales'
    corporate false
  end
end