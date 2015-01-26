# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

cas_options = {
    cas_base_url:  "https://auth.rbdconnect.com/cas/"
}

if Rails.env.production? or Rails.env == 'staging'
    begin
        service_url = Rails.application.routes.url_helpers.root_url
    rescue ArgumentError
        service_url = "http://newcenter.salesmakersinc.com/"
    end
    cas_options = cas_options.merge({ service_url: service_url })
end


CASClient::Frameworks::Rails::Filter.configure(cas_options)

