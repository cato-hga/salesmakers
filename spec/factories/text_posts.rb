# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :text_post do
    person_id 1
    content "MyString"
  end
end
