# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_me_post do
    group_me_group_id 1
    posted_at "2014-09-23 16:22:55"
    json "MyText"
    group_me_user_id 1
    message_num "MyString"
    like_count 1
    person_id "MyString"
  end
end