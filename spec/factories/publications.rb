# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :publication do
    publishable_id 1
    publishable_type "MyString"
  end
end
