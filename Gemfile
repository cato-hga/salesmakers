source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'pg', '0.18.1'
gem 'sass-rails', '5.0.1'
gem 'uglifier', '2.7.0'
gem 'jquery-rails', '4.0.3'
gem 'jbuilder', '2.2.6'
gem 'sdoc', '0.4.1',  group: :doc
gem 'coffee-script', '2.3.0'
gem 'responders', '2.0.2' # Required by rails 4.2.0 for respond_to

# ------ Our gems below this line --------

gem 'jquery-ui-rails', '5.0.5' #Jquery UI gem
gem 'paper_trail', git: 'https://github.com/airblade/paper_trail.git' # Versioning
gem 'chartkick', '1.3.2' # Easy Google Charts creation in Rails
gem 'haml-rails', '0.7.0' # HAML template engine
gem 'rubycas-client', git: 'git://github.com/rubycas/rubycas-client.git' # CAS client for Ruby
gem 'ancestry', git: 'https://github.com/stefankroes/ancestry.git' # Tree-based hierarchies for models
gem 'ransack', git: 'https://github.com/activerecord-hackery/ransack.git' # ActiveRecord search
gem 'ransack_chronic', git: 'https://github.com/ndbroadbent/ransack_chronic.git' # Use Chronic to parse dates with Ransack search
gem 'kaminari', git: 'https://github.com/amatsuda/kaminari.git' # Pagination
gem 'httparty', '0.13.3' # HTTP REST API client
gem 'persistent_httparty', '0.1.2' # Keep connections open when using HTTParty
gem 'namecase', '1.1.0' # Easily turn names into proper cases
gem 'foundation-icons-sass-rails', '3.0.0' # Icon fonts for Foundation
gem 'groupdate', '2.4.0' # Ability to group by dates
gem 'pundit', git: 'https://github.com/elabs/pundit.git' # Role-based authorization
gem 'capistrano', '3.3.5' # Automated deployment
gem 'capistrano-bundler', '1.1.3' # Capistrano bundler integration
gem 'capistrano-rails', '1.1.2' # Capistrano Rails integration
gem 'capistrano-rvm', '0.1.2' # Capistrano RVM integration
gem 'emoji', '1.0.1' # Automatic emoji embeds
gem 'faye', '1.1.0' # GroupMe client websockets
gem 'metric_fu', '4.11.1', require: false # Code metrics
gem 'dragonfly', '1.0.7' # Image and file storage
gem 'auto_html', '1.6.4' # Turn links to embed HTML automatically
gem 'whenever', '0.9.4' # Background tasks scheduled in a flat ruby file.
gem 'postmark-rails', '0.10.0' # Postmark integration. Currently for contact/feedback form
gem 'postmark', '1.5.0' # API wrapper for Postmark
gem 'websocket-rails', '0.7.0' # Web sockets for real-time updates
gem 'spring-commands-rspec', '1.0.4' # Spring RSpec additions
gem 'chronic', '0.10.2' # Natural language date/time parse
gem 'attribute_normalizer', '1.2.0' # Do not allow blanks to save to DB
gem 'nilify_blanks', '1.2.0' # Change empty strings to nil before saving certain models
gem 'render_csv', '2.0.0' # CSV file rendering
gem 'twilio-ruby', '4.2.1' # Twilio SMS and Voice library
gem 'geocoder', '1.2.6' # Geocoding
gem 'gmaps4rails', '2.1.2' # Google Maps
gem 'browser-timezone-rails', '0.0.8' #using the timezone of a user
gem 'roo', git: 'https://github.com/roo-rb/roo.git' # Working with spreadsheets
gem 'roo-xls', git: 'https://github.com/roo-rb/roo-xls.git' # .XLS extension support for Roo. Apparently no version on github
gem 'spreadsheet', '1.0.1' # Extra functionality for Roo
gem 'griddler', '1.1.0' # Incoming email parsing
gem 'griddler-postmark', '1.0.0' # Adapter for griddler for postmark
gem 'goldiloader', '0.0.8' # Automatic eager loading
gem 'sidekiq', '3.3.2' # Background job queuing system
gem 'sinatra', '1.4.5', require: false
gem 'googlecharts', '1.6.10' # Google charts, duh.
gem 'fastimage', git: 'https://github.com/sdsykes/fastimage.git' # Find the size and type of images
gem 'bitly', git: 'https://github.com/philnash/bitly.git' # bit.ly API wrapper
gem 'docusign_rest', '0.1.1' # Docusign API wrapper
gem 'activerecord-session_store', '0.1.1' # Store session data in database instead of cookies
gem 'facter', '2.4.1' # Get number of CPUs to automatically set puma workers
gem 'andand', '1.3.3' # Navigate nested hashes without getting NoMethodErrors
gem 'sunspot_rails', '2.2.0' # Full text search
gem 'sunspot_solr', '2.2.0' # Full text search
gem 'kartograph', '0.2.2' # JSON-to-Object (and vice-versa) mapping
gem 'bcrypt', '3.1.10' # Encryption and hashing (for has_secure_password)
gem 'kiba', '0.6.1' # ETL data processing
gem 'google_timezone', git: 'https://github.com/sck-v/google_timezone.git'
gem 'progress_bar', '1.0.3' # Showing progress for reindexing Solr/Sunspot
gem 'acts_as_taggable_on', '3.0.0.rc2' # Showing progress for reindexing Solr/Sunspot
gem 'activerecord-sqlserver-adapter', '~> 4.2.0' # Microsoft SQL Server Adapter
gem 'tiny_tds', git: 'https://github.com/rails-sqlserver/tiny_tds.git' # Ruby SQL server stuff
gem 'annotate', '2.6.10' # Schema information at the top of model files
gem 'slack-notifier', '1.2.1' # Exception notification on Slack
gem 'regressor', '0.5.7' # Automated regression test generation
gem 'retryable', '2.0.1' # Ability to retry upon exception
gem 'rack-mini-profiler', '0.9.7' #Rails speed benchmarks

group :development do
  gem 'airbrussh', '0.3.0', require: false
  gem 'letter_opener', '1.3.0' # Open sent emails in a browser during development
  gem 'spring', '1.2.0' # Rails environment preloading
  gem 'better_errors', '2.1.1' # More in-depth error messages and debugging
  gem 'binding_of_caller', '0.7.2' # Required by better_errors
  gem 'hirb', '0.7.2' # Pretty console printing of model information
  gem 'awesome_print', '1.6.1' # Pretty console printing
  gem 'coderay', '1.1.0'
  gem 'coolline', '0.5.0'
  gem 'guard-rspec', '4.5.0', require: false # Automated spec runs
  gem 'traceroute', '0.4.0' # Find dead routes and missing controller actions.
  gem 'rails_best_practices', '1.15.4' #Gem to output best practices
  gem 'web-console', '~> 2.0' # Web console (new to rails 4.2)
  gem 'parallel_tests', '1.3.5' # Parallel testing
  gem 'seed_dump', '3.2.2' # Dump database records to seeds
  gem 'pry', '0.10.1' # Provides an alternative console; also really cool binding.pry debug
  gem 'capistrano-rails-console', '0.5.2' # Access to Rails console on remote machine from cap command!
  gem 'capistrano-faster-assets', '1.0.2' # Precompile only the assets that have changed on deploys
  gem 'lol_dba', '2.0.0' # Find missing indexes
end

group :test do
  gem 'capybara', '2.4.4' # Testing views and interactions
  gem 'capybara-webkit', '1.3.1' # Javascript driver for capybara
  gem 'launchy', '2.4.3' # Open applications (save_and_open_page)
  gem 'factory_girl_rails', '4.5.0' # Easily create mock objects for testing
  gem 'shoulda-matchers', '2.7.0', require: false # Easy model validation test methods
  gem 'webmock', '1.20.4' # Stubbing of HTTP requests
  gem 'vcr', '2.9.3' # Store and use real HTTP response data in tests
  gem 'codeclimate-test-reporter', '0.4.5', require: nil # Code Climate test coverage
  gem 'database_rewinder', '0.4.2' # Database Cleaner alternative
  gem 'timecop', '0.7.3' # Alter times in testing
  gem 'rack_session_access', '0.1.1' # Ability to access session hash from tests
  gem 'simplecov' # Backup code coverage, since CodeClimate cant see our parallel tests
end

group :production do
  gem 'newrelic_rpm', git: 'https://github.com/newrelic/rpm.git'
end

group :development, :test do
  gem 'rspec-rails', '3.1.0' # Rspec test framework
  gem 'faker', '1.4.3' # Easily create fake data for mocked objects
end

group :development, :production, :staging do
  gem 'swiper-rails', '1.0.2' # Content slider
  gem 'active_shipping', '1.4.2' # Shipping integration for many carriers
end


group :production, :staging do
  gem 'rack-cache', '1.2', require: 'rack/cache' # Cache, used by Dragonfly
  gem 'exception_notification', '4.1.1' # Send notification of uncaught Exceptions to developers (us!)
end