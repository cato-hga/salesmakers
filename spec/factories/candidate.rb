FactoryGirl.define do

  factory :candidate do
    first_name 'Test'
    last_name 'Candidate'
    sequence(:mobile_phone, (1..9).cycle) { |n| "727498518#{n}" }
    email 'test@user.com'
    zip '33711'
    project
    association :created_by, factory: :person
    active true
  end

end