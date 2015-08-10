# == Schema Information
#
# Table name: group_me_posts
#
#  id                :integer          not null, primary key
#  group_me_group_id :integer          not null
#  posted_at         :datetime         not null
#  json              :text             not null
#  created_at        :datetime
#  updated_at        :datetime
#  group_me_user_id  :integer          not null
#  message_num       :string           not null
#  like_count        :integer          default(0), not null
#  person_id         :integer
#

# # Read about factories at https://github.com/thoughtbot/factory_girl
#
# FactoryGirl.define do
#   factory :group_me_post do
#     association :group_me_group
#     posted_at "2014-09-23 16:22:55"
#     json "MyText"
#     association :group_me_user
#     message_num "MyString"
#     like_count 1
#     person
#   end
# end
