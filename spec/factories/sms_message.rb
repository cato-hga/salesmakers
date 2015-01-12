FactoryGirl.define do

  factory :sms_message do
    from_num '7272286225'
    to_num '8635214572'
    message 'This is a message that lives in a factory.'
  end

end