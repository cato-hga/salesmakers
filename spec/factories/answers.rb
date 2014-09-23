# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    person_id 1
    question_id 1
    content "MyText"
  end
end
