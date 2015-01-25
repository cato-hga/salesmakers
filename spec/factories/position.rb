FactoryGirl.define do

  factory :position do
    name 'Vonage Retail Sales Specialist'
    leadership false
    all_field_visibility false
    all_corporate_visibility false
    association :department, strategy: :build_stubbed
    field true
    hq false
  end
end