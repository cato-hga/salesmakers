FactoryGirl.define do

  factory :area_type do
    name 'Vonage Retail Region'
    project
  end

  factory :vonage_retail_market, class: AreaType do
    name 'Vonage Retail Market'
    project
  end
end