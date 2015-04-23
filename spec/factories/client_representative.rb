FactoryGirl.define do

  factory :client_representative do
    client
    name 'Foo Barson'
    email 'foo@barson.com'
    password 'foobar'
    password_confirmation 'foobar'
  end

end