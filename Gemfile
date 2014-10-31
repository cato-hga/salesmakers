source 'https://rubygems.org'

gem 'rails', '4.1.1'
gem 'pg', '0.17.1'
gem 'sass-rails', '4.0.3'
gem 'uglifier', '1.3.0'
gem 'jquery-rails', '3.1.0'
gem 'jbuilder', '2.0'
gem 'sdoc', '0.4.0',  group: :doc
gem 'coffee-script', '2.3.0'

# ------ Our gems below this line --------

gem 'chartkick', '1.2.5' # Easy Google Charts creation in Rails
gem 'haml-rails', '0.5.3' # HAML template engine
gem 'rubycas-client', git: 'git://github.com/rubycas/rubycas-client.git' # CAS client for Ruby
gem 'sentient_user', git: 'git://github.com/house9/sentient_user.git' # Allow current_user to work in models
gem 'ancestry', git: 'https://github.com/stefankroes/ancestry.git' # Tree-based hierarchies for models
gem 'ransack', '1.2.3' # ActiveRecord search
gem 'kaminari', '0.16.1' # Pagination
gem 'httparty', '0.13.1' # HTTP REST API client
gem 'namecase', '1.1.0' # Easily turn names into proper cases
gem 'foundation-icons-sass-rails', '3.0.0' # Icon fonts for Foundation
gem 'groupdate', '2.2.1' # Ability to group by dates
gem 'swiper-rails', '1.0.2' # Content slider
gem 'pundit', git: 'https://github.com/elabs/pundit.git' # Role-based authorization
gem 'capistrano', '3.2.1' # Automated deployment
gem 'capistrano-bundler', '1.1.2', require: false # Capistrano bundler integration
gem 'capistrano-rails', '1.1.1', require: false # Capistrano Rails integration
gem 'capistrano-rvm', '0.1.1', require: false # Capistrano RVM integration
gem 'capistrano3-puma', '0.6.1', require: false # Capistrano Puma integration
gem 'puma', '2.9.0' # Web server
gem 'foreman', '0.74.0' # Deployment automation
gem 'emoji', '1.0.1' # Automatic emoji embeds
gem 'faye', '1.0.3' # GroupMe client websockets
gem 'metric_fu' # Code metrics
gem 'dragonfly', '1.0.7' # Image and file storage
gem 'remotipart', '1.2.1' # Allow remote form submission via AJAX for file uploads
gem 'auto_html', '1.6.4' # Turn links to embed HTML automatically
gem 'whenever', '0.9.2' # Background tasks scheduled in a flat ruby file.
gem 'mail_form', '1.5.0' # Gem for contact/feedback form. Using based on tutorial: http://rubyonrailshelp.wordpress.com/2014/01/08/rails-4-simple-form-and-mail-form-to-make-contact-form/
gem 'simple_form', '3.0.2' # For contact/feedback form
gem 'postmark-rails', '0.8.0' # Postmark integration. Currently for contact/feedback form
gem 'websocket-rails', '0.7.0' # Web sockets for real-time updates
gem 'spring-commands-rspec', '1.0.2' # Spring RSpec additions
# gem 'foundation-datetimepicker-rails', '0.1.3' # Date/Time picker for Foundation
gem 'chronic', '0.10.2' # Natural language date/time parse
gem 'attribute_normalizer', '1.2.0' # Do not allow blanks to save to DB

group :development do
  gem 'letter_opener', '1.2.0' # Open sent emails in a browser during development
  gem 'spring', '1.1.3' # Rails environment preloading
  gem 'better_errors', '1.1.0' # More in-depth error messages and debugging
  gem 'binding_of_caller', '0.7.2' # Required by better_errors
  gem 'hirb', '0.7.2' # Pretty console printing of model information
  gem 'awesome_print', '1.2.0' # Pretty console printing
  gem 'coderay', '1.1.0'
  gem 'coolline', '0.4.3'
  gem 'guard-rspec', '4.2.10', require: false # Automated spec runs
  # gem 'bullet' # Database query analysis for performance tuning.
  gem 'traceroute', '0.4.0' # Find dead routes and missing controller actions.
  #gem 'rack-mini-profiler', '0.9.2' #Performance profiling
  gem 'stack_rescue', '0.0.1' # Output stackoverflow messages based on error messages on server logs
end

group :test do
  gem 'capybara', '2.3.0' # Testing views and interactions
  gem 'capybara-webkit', '1.3.0' #Javascript driver for capybara
  gem 'factory_girl_rails', '4.4.1' # Easily create mock objects for testing
  gem 'database_cleaner', '1.3.0' # Automated cleaning of test database between spec runs
  gem 'simplecov', '0.9.0', require: false # Easily see amount of code covered by tests
  gem 'shoulda-matchers', '2.6.2', require: false # Easy model validation test methods
  gem 'webmock', '1.20.0' # Stubbing of HTTP requests
  gem 'vcr', '2.9.3' # Store and use real HTTP response data in tests
end

group :development, :test do
  gem 'rspec-rails', '3.0.1' # Rspec test framework
  gem 'faker', '1.3.0' # Easily create fake data for mocked objects
end

group :production do
  gem 'newrelic_rpm' # NewRelic agent
  gem 'rack-cache', require: 'rack/cache' # Cache, used by Dragonfly
end