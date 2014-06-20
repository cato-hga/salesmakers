FactoryGirl.define do
  factory :von_retail_sales_department, class: Department do
    name 'Vonage Retail Sales'
    corporate false
  end

  factory :von_retail_sales_specialist_position, class: Position do
    name 'Vonage Retail Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    department { create :von_retail_sales_department }
  end

  factory :von_retail_sales_specialist_person, class: Person do
    first_name 'Test'
    last_name 'User'
    display_name 'Test User'
    email 'test@rbd-von.com'
    personal_email 'icheckthistoomuch@gmail.com'
    position { create :von_retail_sales_specialist_position }
  end

  factory :von_client, class: Client do
     name 'Vonage'
  end

  factory :von_retail_project, class: Project do
    name 'Vonage Retail'
    client { create :von_client }
  end

  factory :von_region_area_type, class: AreaType do
    name 'Region'
    project { create :von_retail_project }
  end

  factory :von_east_retail_region_area, class: Area do
    name 'East Retail Region'
    area_type { create :von_region_area_type }
  end
end