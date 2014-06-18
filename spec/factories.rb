FactoryGirl.define do
  factory :von_retail_sales_department, class: Department do
    name 'Vonage Retail Sales'
    corporate false
  end

  factory :sales_specialist_position, class: Position do
    name 'Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    department { create :von_retail_sales_department }
  end
end