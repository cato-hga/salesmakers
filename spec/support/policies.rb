def log_in(person)
  CASClient::Frameworks::Rails::Filter.fake(person.email)
end

def redirect_back_to_home
  require.env["HTTP_REFERER"] =  root_url
end