FactoryGirl.define do

  factory :candidate do
    first_name 'Test'
    last_name 'Candidate'
    sequence(:mobile_phone, (1..9).cycle) { |n| "800555100#{n}" }
    email { generate(:sequential_email) }
    zip '33711'
    association :created_by, factory: :person
    active true
    association :candidate_source
  end

end