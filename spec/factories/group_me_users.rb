# == Schema Information
#
# Table name: group_me_users
#
#  id                :integer          not null, primary key
#  group_me_user_num :string           not null
#  person_id         :integer
#  name              :string           not null
#  avatar_url        :string
#  created_at        :datetime
#  updated_at        :datetime
#

# # Read about factories at https://github.com/thoughtbot/factory_girl
#
FactoryGirl.define do
  factory :group_me_user do
    group_me_user_num '123'
    name 'A GroupMe User'
    person
  end
end
