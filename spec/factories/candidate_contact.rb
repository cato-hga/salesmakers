FactoryGirl.define do

  factory :candidate_contact do
    contact_method 0
    candidate
    person
    notes 'This is an example note'
  end

end