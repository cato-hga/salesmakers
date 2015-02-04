FactoryGirl.define do

  factory :connect_user do
    skip_create

    id '0AA3ECF402ABCEB6280D1FC4C8DE8FCD'
    updated DateTime.now - 1.month
    created DateTime.now - 2.months
    name 'Test Connect User'
    email 'test@connect_user.com'
  end
end