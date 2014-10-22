# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_me_post do
    association :group_me_group, strategy: :build_stubbed
    posted_at "2014-09-23 16:22:55"
    json "MyText"
    association :group_me_user, strategy: :build_stubbed
    message_num "MyString"
    like_count 1
    association :person, strategy: :build_stubbed
  end
end
