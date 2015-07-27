FactoryGirl.define do

  factory :roster_verification_session do
    association :creator, factory: :person
  end

end