# == Schema Information
#
# Table name: group_me_groups
#
#  id         :integer          not null, primary key
#  group_num  :integer          not null
#  area_id    :integer
#  name       :string           not null
#  avatar_url :string
#  created_at :datetime
#  updated_at :datetime
#  bot_num    :string
#

# # Read about factories at https://github.com/thoughtbot/factory_girl
#
FactoryGirl.define do
  factory :group_me_group do
    group_num 1
    name 'Test GroupMe Group'
    area
  end
end
