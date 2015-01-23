# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, make a
# separate helper file that requires this one and then use it only in the specs
# that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
#Code Climage Test coverage
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'pundit/rspec'
require 'support/pundit_matcher'
require 'database_cleaner'
require 'factory_girl_rails'

ActiveRecord::Migration.maintain_test_schema!
RSpec.configure do |config|
  # Uncomment the next line to troubleshoot spec times!
  # config.profile_examples = 10
  
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      #DatabaseCleaner.clean_with :truncation
      #FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with :truncation
    end
    FactoryGirl.create :administrator_person
    # admin = Person.find_by(email: 'retailingw@retaildoneright.com')
    # admin.destroy if admin
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:all) do
    CASClient::Frameworks::Rails::Filter.fake("retailingw@retaildoneright.com")
  end

  config.before(:each) do |spec|
    DatabaseCleaner.strategy = spec.metadata[:js] ? :deletion : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do |spec|
    DatabaseCleaner.clean
    begin
      ActiveRecord::Base.connection.send :rollback_transaction_records, true
    rescue
    end
    if spec.metadata[:js]
      FactoryGirl.create :administrator_person
      ActiveRecord::Base.connection_pool.disconnect!
    end
  end
end
