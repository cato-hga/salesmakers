FactoryGirl.define do

  factory :docusign_nos do
    association :person
    association :employment_end_reason
    envelope_guid 'cc51f867-d0c1-413a-b427-36951aa1b335'
    last_day_worked Date.yesterday
    termination_date Date.today
  end
end
