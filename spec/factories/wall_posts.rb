# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wall_post do
    publication
    association :wall, factory: :person_wall
    person
  end
end
