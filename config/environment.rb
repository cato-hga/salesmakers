# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => "https://auth.rbdconnect.com/cas/"
)