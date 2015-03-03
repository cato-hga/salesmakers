FactoryGirl.define do

  factory :job_offer_detail do
    association :candidate
    sent DateTime.now
  end
end