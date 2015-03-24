threads 8, 32
workers 4
environment ENV['RAILS_ENV'] || 'production'
bind 'unix:///opt/oneconnect/shared/tmp/sockets/puma.sock'

on_worker_boot do
  require "active_record"
  cwd = File.dirname(__FILE__)+"/.."
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RAILS_ENV"]])
end