# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

cas_options = {
    cas_base_url:  "http://auth.rbdconnect.com/cas/"
}

if Rails.env.production? or Rails.env == 'staging'
    service_url = "http://newcenter.salesmakersinc.com/" if Rails.env.production?
    service_url = "http://staging.salesmakersinc.com/" if Rails.env == 'staging'
    cas_options = cas_options.merge({ service_url: service_url })
end

CASClient::Frameworks::Rails::Filter.configure(cas_options)