FactoryGirl.define do

  factory :comcast_customer_note do
    comcast_customer
    person
    note 'This is a note'
  end

end