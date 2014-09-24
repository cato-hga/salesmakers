# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    person_id 1
    title "MyString"
    content "MyText"
  end
end
