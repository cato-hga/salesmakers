source 'https://rubygems.org'

gem 'rails', '4.2.0' # Was 4.1.1 01/21/2015
gem 'pg', '0.18.1' # Was 0.17.1 01/21/2015
gem 'sass-rails', '5.0.1' # Was 4.0.3 01/21/2015
gem 'uglifier', '2.7.0' # Was 1.3.0 01/21/2015
gem 'jquery-rails', '4.0.3' # Was 3.1.0 01/21/2015
gem 'jbuilder', '2.2.6' # Was 2.0 01/21/2015
gem 'sdoc', '0.4.1',  group: :doc # Was 0.4.0 01/21/2015
gem 'coffee-script', '2.3.0'
gem 'responders', '2.0.2' # Required by rails 4.2.0 for respond_to

# ------ Our gems below this line --------

gem 'chartkick', '1.3.2' # Was 1.2.5 01/21/2015 - Easy Google Charts creation in Rails
gem 'haml-rails', '0.7.0' # Was 0.5.3 01/21/2015 - HAML template engine
gem 'rubycas-client', git: 'git://github.com/rubycas/rubycas-client.git' # CAS client for Ruby
#gem 'sentient_user', git: 'git://github.com/house9/sentient_user.git' # Allow current_user to work in models
gem 'ancestry', git: 'https://github.com/stefankroes/ancestry.git' # Tree-based hierarchies for models
gem 'ransack', '1.6.2' # Was 1.2.3 01/21/2015 - ActiveRecord search
gem 'kaminari', '0.16.2' # Was 0.16.1 01/21/2015 - Pagination
gem 'httparty', '0.13.3' # Was 0.13.1 01/21/2015 - HTTP REST API client
gem 'namecase', '1.1.0' # Easily turn names into proper cases
gem 'foundation-icons-sass-rails', '3.0.0' # Icon fonts for Foundation
gem 'groupdate', '2.4.0' # Was 2.2.1 01/21/2015 - Ability to group by dates
gem 'pundit', git: 'https://github.com/elabs/pundit.git' # Role-based authorization
gem 'capistrano', '3.3.5' # Was 3.2.1 01/21/2015 - Automated deployment
gem 'capistrano-bundler', '1.1.3' # Was 1.1.2 01/21/2015 - Capistrano bundler integration
gem 'capistrano-rails', '1.1.2' # Was 1.1.1 01/21/2015 - Capistrano Rails integration
gem 'capistrano-rvm', '0.1.2' # Was 0.1.1 01/21/2015 - Capistrano RVM integration
gem 'capistrano3-puma', '0.8.3' # Was 0.6.1 01/21/2015 - Capistrano Puma integration
gem 'puma', '2.11.0' # Was 2.9.0 01/21/2015 - Web server
gem 'emoji', '1.0.1' # Automatic emoji embeds
gem 'faye', '1.1.0' # Was 1.0.3 01/21/2015 - GroupMe client websockets
gem 'metric_fu', '4.11.1', require: false # Code metrics
gem 'dragonfly', '1.0.7' # Image and file storage
gem 'remotipart', '1.2.1' # Allow remote form submission via AJAX for file uploads
gem 'auto_html', '1.6.4' # Turn links to embed HTML automatically
gem 'whenever', '0.9.4' # Was 0.9.2 01/21/2015 - Background tasks scheduled in a flat ruby file.
gem 'postmark-rails', '0.10.0' # Was 0.9.0 01/21/2015 - Postmark integration. Currently for contact/feedback form
gem 'websocket-rails', '0.7.0' # Web sockets for real-time updates
gem 'spring-commands-rspec', '1.0.4' # Was 1.0.2 01/21/2015 - Spring RSpec additions
# gem 'foundation-datetimepicker-rails', '0.1.3' # Date/Time picker for Foundation
gem 'chronic', '0.10.2' # Natural language date/time parse
gem 'attribute_normalizer', '1.2.0' # Do not allow blanks to save to DB
gem 'nilify_blanks', '1.2.0' # Was 1.1.0 01/21/2015 - Change empty strings to nil before saving certain models
gem 'render_csv', '2.0.0' # CSV file rendering
gem 'twilio-ruby', '3.14.4' # Was 3.14.2 01/21/2015 - Twilio SMS and Voice library
gem 'geocoder', '1.2.6' # Geocoding
gem 'gmaps4rails', '2.1.2' # Google Maps
gem 'browser-timezone-rails', '0.0.8' #using the timezone of a user
gem 'roo', git: 'https://github.com/roo-rb/roo.git' # Working with spreadsheets
gem 'spreadsheet', '1.0.1' # Extra functionality for Roo
gem 'griddler', '1.1.0' # Incoming email parsing
gem 'griddler-postmark', '1.0.0' # Adapter for griddler for postmark
gem 'goldiloader', '0.0.8' # Automatic eager loading

group :development do
  gem 'letter_opener', '1.3.0' # Was 1.2.0 01/21/2015 - Open sent emails in a browser during development
  gem 'spring', '1.2.0' # Was 1.1.3 01/21/2015 - Rails environment preloading
  gem 'better_errors', '2.1.1' # Was 1.1.0 01/21/2015 - More in-depth error messages and debugging
  gem 'binding_of_caller', '0.7.2' # Required by better_errors
  gem 'hirb', '0.7.2' # Pretty console printing of model information
  gem 'awesome_print', '1.6.1' # Was 1.2.0 01/21/2015 - Pretty console printing
  gem 'coderay', '1.1.0'
  gem 'coolline', '0.5.0' # Was 0.4.3 01/21/2015
  gem 'guard-rspec', '4.5.0', require: false # Was 4.2.10 01/21/2015 - Automated spec runs
  gem 'traceroute', '0.4.0' # Find dead routes and missing controller actions.
  gem 'rails_best_practices', '1.15.4' #Gem to output best practices
  gem 'web-console', '~> 2.0' # Web console (new to rails 4.2)
end


group :test do
  gem 'capybara', '2.4.4' # Was 2.3.0 01/21/2015 - Testing views and interactions
  gem 'capybara-webkit', '1.3.1' # Was 1.3.0 01/21/2015 - Javascript driver for capybara
  gem 'factory_girl_rails', '4.5.0' # Was 4.4.1 01/21/2015 - Easily create mock objects for testing
  gem 'shoulda-matchers', '2.7.0', require: false # Was 2.6.2 01/21/2015 - Easy model validation test methods
  gem 'webmock', '1.20.4' # Was 1.20.0 01/21/2015 - Stubbing of HTTP requests
  gem 'vcr', '2.9.3' # Store and use real HTTP response data in tests
  gem 'codeclimate-test-reporter', '0.4.5', require: nil #codeclimate test coverage
  gem 'database_rewinder', '0.4.2' #Database Cleaner alternative
end

group :production do
  gem 'newrelic_rpm', '3.9.9.275' # NewRelic agent
end

group :development, :test do
  gem 'rspec-rails', '3.1.0' # Was 3.0.1 01/21/2015 - Rspec test framework
  gem 'faker', '1.4.3' # Was 1.3.0 01/21/2015 - Easily create fake data for mocked objects
end

group :development, :production, :staging do
  gem 'swiper-rails', '1.0.2' # Content slider
  gem 'active_shipping', '1.0.0pre1' # Was 0.12.4 01/21/2015 - Shipping integration for many carriers
  gem 'pghero', '0.1.9' # Postgres database insights
end


group :production, :staging do
  gem 'rack-cache', '1.2', require: 'rack/cache' # Cache, used by Dragonfly
  gem 'exception_notification', '4.0.1' # Send notification of uncaught Exceptions to developers (us!)
end