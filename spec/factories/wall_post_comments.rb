# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wall_post_comment do
    wall_post_id 1
    person_id 1
    comment "MyText"
  end
end
