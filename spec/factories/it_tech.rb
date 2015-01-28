FactoryGirl.define do

  factory :it_tech_person, class: Person do
    first_name 'IT'
    last_name 'Tech'
    email 'ittech@salesmakersinc.com'
    mobile_phone '5555555555'
    association :position, factory: :it_tech_position, strategy: :build_stubbed
  end

  factory :it_tech_position, class: Position do
    name 'IT Tech'
    leadership false
    all_field_visibility true
    all_corporate_visibility true
    association :department, factory: :information_technology_department, strategy: :build_stubbed
    field false
    hq true
    trait :twilio do
      twilio_number '+12345678901'
    end
  end

  factory :information_technology_department, class: Department do
    name 'Information Technology'
    corporate true
  end
end