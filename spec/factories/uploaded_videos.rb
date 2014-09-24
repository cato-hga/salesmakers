# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uploaded_video do
    url "MyString"
    person_id 1
    score 1
  end
end
