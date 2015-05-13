FactoryGirl.define do

  factory :candidate_note do
    candidate
    person
    note 'This is a note'
  end

end