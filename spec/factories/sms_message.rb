FactoryGirl.define do

  factory :sms_message do
    from_num '8005551002'
    to_num '8005551001'
    message 'This is a message that lives in a factory.'
    sid 'SM12345678901234567890'
  end

end