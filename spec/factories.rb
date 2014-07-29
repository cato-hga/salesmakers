FactoryGirl.define do
  factory :department do
    name 'Vonage Retail Sales'
    corporate false
  end

  factory :position do
    name 'Vonage Retail Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    department
  end

  factory :person do
    first_name 'Test'
    last_name 'User'
    email 'test123omgstupidfactories@rbd-von.com'
    mobile_phone '5551234567'
    position
  end

  factory :client do
     name 'Vonage'
  end

  factory :project do
    name 'Vonage Retail'
    client
  end

  factory :area_type do
    name 'Vonage Retail Region'
    project
  end

  factory :area do
    name 'East Retail Region'
    area_type
    project
  end

  factory :person_area do
    association :person, strategy: :build
    area
    manages false
  end

  factory :technology_service_provider do
    name 'Verizon'
  end

  factory :line do
    identifier '7274985180'
    technology_service_provider
    contract_end_date Date.today + 3.months
  end

  factory :line_state do
    name 'Suspended'
  end

  factory :device_manufacturer do
    name 'Samsung'
  end

  factory :device_model do
    name 'GalaxyTab 3'
    device_manufacturer
  end

  factory :device do
    identifier '12345'
    serial '256691513608935569'
    device_model
    line
  end

  factory :device_state do
    name 'Repair'
  end

  factory :log_entry do
    association :person, strategy: :build
    action 'create'
    trackable { build :device }
  end


  factory :device_deployment do
    device
    person
    started Date.today - 2.months
  end

  factory :permission_group do
    name 'Permissions'
  end

  factory :permission do
    key 'permission_group_index'
    description 'Can view index of permission groups'
    permission_group
  end

  factory :profile do
    association :person, strategy: :build
  end

  factory :theme do
    name 'dark'
    display_name 'Dark'
  end
end
