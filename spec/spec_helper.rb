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
require 'support/deferred_garbage_collection'
require 'factory_girl_rails'

RSpec.configure do |config|
  # Uncomment the next line to troubleshoot spec times!
  # config.profile_examples = 10

  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    DeferredGarbageCollection.start
    DatabaseRewinder.clean_all
    #FactoryGirl.lint
  end

  config.after :suite do
    DeferredGarbageCollection.reconsider
  end

  config.before(:each) do
    CASClient::Frameworks::Rails::Filter.fake("retailingw@retaildoneright.com")
  end
  config.after(:each) do
    DatabaseRewinder.clean
  end
end