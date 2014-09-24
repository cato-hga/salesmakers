# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wall_post do
    publication_id 1
    wall_id 1
    person_id 1
  end
end
