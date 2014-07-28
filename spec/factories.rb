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
    department { build_stubbed :von_retail_sales_department }
  end

  factory :von_retail_sales_specialist_person, class: Person do
    first_name 'Test'
    last_name 'User'
    display_name 'Test User'
    email 'test123omgstupidfactories@rbd-von.com'
    personal_email 'icheckthistoomuch@gmail.com'
    office_phone '7274985180'
    mobile_phone '5551234567'
    home_phone '7895123012'
    position { build_stubbed :von_retail_sales_specialist_position }
    eid 55555
  end

  factory :von_client, class: Client do
     name 'Vonage'
  end

  factory :von_retail_project, class: Project do
    name 'Vonage Retail'
    client { build_stubbed :von_client }
  end

  factory :von_region_area_type, class: AreaType do
    name 'Vonage Retail Region'
    project { build_stubbed :von_retail_project }
  end

  factory :von_east_retail_region_area, class: Area do
    name 'East Retail Region'
    area_type { build_stubbed :von_region_area_type }
    project { build_stubbed :von_retail_project }
  end

  factory :von_retail_east_sales_specialist_person_area, class: PersonArea do
    person { build_stubbed :von_retail_sales_specialist_person }
    area { build_stubbed :von_east_retail_region_area }
    manages false
  end

  factory :verizon_technology_service_provider, class: TechnologyServiceProvider do
    name 'Verizon'
  end

  factory :verizon_line, class: Line do
    identifier '7274985180'
    contract_end_date Date.today + 3.months
    technology_service_provider { build_stubbed :verizon_technology_service_provider }
  end

  factory :suspended_line_state, class: LineState do
    name 'Suspended'
  end

  factory :samsung_device_manufacturer, class: DeviceManufacturer do
    name 'Samsung'
  end

  factory :samsung_galaxytab3_device_model, class: DeviceModel do
    name 'GalaxyTab 3'
    device_manufacturer { build_stubbed :samsung_device_manufacturer }
  end

  factory :samsung_galaxytab3_device, class: Device do
    identifier '12345'
    serial '256691513608935569'
    device_model { build_stubbed :samsung_galaxytab3_device_model }
    line { build_stubbed :verizon_line }
    person { build_stubbed :von_retail_sales_specialist_person }
    secondary_identifier '99000000'
  end

  factory :repair_device_state, class: DeviceState do
    name 'Repair'
  end

  factory :create_person_log_entry, class: LogEntry do
    person { build_stubbed :von_retail_sales_specialist_person }
    action 'create'
    trackable { build_stubbed :samsung_galaxytab3_device }
  end


  factory :device_deployment, class: DeviceDeployment do
    device { build_stubbed :samsung_galaxytab3_device }
    person { build_stubbed :von_retail_sales_specialist_person }
    started Date.today - 2.months
    ended Date.today - 3.days
    tracking_number '12345678910'
    comment 'This is a comment'
  end

  factory :smiles, class: Person do
    first_name 'Stephen'
    last_name 'Miles'
    display_name 'Stephen Miles'
    email 'smiles@retaildoneright.com'
    personal_email 'milessa42@gmail.com'
    mobile_phone '8137164150'
    position { build_stubbed :von_retail_sales_specialist_position }
  end

  factory :smiles_profile, class: Profile do
    person { build_stubbed :smiles }
    theme_name 'dark'
  end

  factory :dark_theme, class: Theme do
    name 'dark'
    display_name 'Dark'
  end

  factory :people_permission_group, class: PermissionGroup do
    name 'People'
  end

  factory :person_edit_permission, class: Permission do
    key 'person_edit'
    description 'Can edit people'
    permission_group { build_stubbed :people_permission_group }
  end
end
