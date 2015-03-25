FactoryGirl.define do

  factory :screening do
    person
    sex_offender_check 0
    public_background_check 0
    private_background_check 0
    drug_screening 0
  end
end