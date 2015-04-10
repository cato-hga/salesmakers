FactoryGirl.define do
  factory :candidate_drug_test do
    scheduled false
    association :candidate
  end

end
