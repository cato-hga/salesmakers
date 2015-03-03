FactoryGirl.define do

  factory :candidate do
    first_name 'Test'
    last_name 'Candidate'
    mobile_phone '7274985180'
    email 'test@user.com'
    zip '33711'
    association :project
  end
end