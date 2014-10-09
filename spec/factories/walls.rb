# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person_wall, class: Wall do
    wallable_id 1
    wallable_type "Person"
  end
end
