FactoryGirl.define do

  factory :unmatched_candidate do
    last_name 'Candidate'
    first_name 'Unmatched'
    email 'ummatched@test.com'
    score '82.34'
  end
end
