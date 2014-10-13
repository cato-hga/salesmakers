FactoryGirl.define do

  # May not need these. Delete eventually!

  # factory :region_with_one_market, class: Area do
  #   name 'Tampa Retail Territory'
  #   area_type
  #   project
  # end
  #
  # factory :markets_with_territories, class: Area do
  #   name 'Florida Retail Market'
  #   area_type
  # end

  factory :area do
    name 'A Test Area'
    area_type strategy: :build_stubbed
  end
end