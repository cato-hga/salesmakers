FactoryGirl.define do

  factory :email_message do
    from_email 'from@salesmakersinc.com'
    to_email 'to@salesmakersinc.com'
    content 'This is an email la-di-da.'
  end

end