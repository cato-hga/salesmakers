FactoryGirl.define do

  factory :poll_question do
    question 'What sample question would you like to use?'
    start_time Time.now
  end

end