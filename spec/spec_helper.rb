# Uncomment the next two lines for code coverage
require 'simplecov'
SimpleCov.start 'rails'
require 'pundit/rspec'
require 'support/pundit_matcher'
require 'database_cleaner'
require 'factory_girl_rails'

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    Permission.destroy_all
    PermissionGroup.destroy_all
    Person.destroy_all
    Position.destroy_all
    Department.destroy_all
    FactoryGirl.create :administrator_person
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
