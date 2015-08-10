FactoryGirl.define do

  factory :process_log do
    process_class 'FooBar'
    records_processed 1
  end

end