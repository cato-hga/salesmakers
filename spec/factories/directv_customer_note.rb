FactoryGirl.define do

  factory :directv_customer_note do
    dirctv_customer
    person
    note 'This is a note'
  end

end