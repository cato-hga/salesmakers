require 'facter'
cpus = Facter.value('processors')['count']

if cpus and cpus > 4
  threads cpus, cpus
  workers cpus
else
  threads 1, 16
  workers 4
end
preload_app!
environment ENV['RAILS_ENV'] || 'production'
bind 'unix:///opt/oneconnect/shared/tmp/sockets/puma.sock'

on_worker_boot do
  require "active_record"
  cwd = File.dirname(__FILE__)+"/.."
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RAILS_ENV"]])
end