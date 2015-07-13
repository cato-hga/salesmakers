FactoryGirl.define do

  factory :report_query do
    name 'Foo Query'
    category_name 'Bar Category'
    database_name Rails.configuration.database_configuration[Rails.env]['database']
    query "SELECT 'YADA YADA'::text AS \"Column Name\""
    permission_key 'foo_query'
  end

end