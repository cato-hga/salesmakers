def log_in(person)
  CASClient::Frameworks::Rails::Filter.fake(person.email)
end