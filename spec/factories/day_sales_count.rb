FactoryGirl.define do

  factory :day_sales_count do
    association :saleable, factory: :person
    day Date.today
    sales 3
  end

end