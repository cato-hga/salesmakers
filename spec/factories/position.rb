FactoryGirl.define do

  factory :position do
    name 'Vonage Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    association :department
    field true
    hq false
  end
end