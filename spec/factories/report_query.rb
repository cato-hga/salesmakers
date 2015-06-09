FactoryGirl.define do

  factory :report_query do
    name 'Foo Query'
    category_name 'Bar Category'
    database_name Rails.configuration.database_configuration[Rails.env]['database']
    query "SELECT current_timestamp AS \"Time Stamp\""
    permission_key 'foo_query'
  end

end