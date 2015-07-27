FactoryGirl.define do

  factory :roster_verification do
    association :creator, factory: :person
    person
    status 0
    roster_verification_session
  end

end