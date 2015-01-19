FactoryGirl.define do

  factory :person_address do
    person
    line_1 '111 2nd Ave NE'
    city 'St. Petersburg'
    state 'FL'
    zip '33701'
  end

end