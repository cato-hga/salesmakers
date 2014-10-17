# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :text_post do
    person
    content 'This is the postest with the mostest.'
  end
end
