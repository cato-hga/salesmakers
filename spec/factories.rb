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
    office_phone '7274985180'
    mobile_phone '5551234567'
    home_phone '7895123012'
    position { create :von_retail_sales_specialist_position }
    eid 55555
  end

  factory :von_client, class: Client do
     name 'Vonage'
  end

  factory :von_retail_project, class: Project do
    name 'Vonage Retail'
    client { create :von_client }
  end

  factory :von_region_area_type, class: AreaType do
    name 'Vonage Retail Region'
    project { create :von_retail_project }
  end

  factory :von_east_retail_region_area, class: Area do
    name 'East Retail Region'
    area_type { create :von_region_area_type }
    project { create :von_retail_project }
  end

  factory :von_retail_east_sales_specialist_person_area, class: PersonArea do
    person { create :von_retail_sales_specialist_person }
    area { create :von_east_retail_region_area }
    manages false
  end

  factory :verizon_technology_service_provider, class: TechnologyServiceProvider do
    name 'Verizon'
  end

  factory :verizon_line, class: Line do
    identifier '7274985180'
    contract_end_date Date.today + 3.months
    technology_service_provider { create :verizon_technology_service_provider }
  end

  factory :suspended_line_state, class: LineState do
    name 'Suspended'
  end

  factory :samsung_device_manufacturer, class: DeviceManufacturer do
    name 'Samsung'
  end
end