FactoryGirl.define do

  factory :permission do
    key 'permission_group_index'
    description 'Can view index of permission groups'
    permission_group
  end
end