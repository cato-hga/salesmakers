# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'oneconnect'
set :repo_url, 'git@rbd.unfuddle.com:rbd/reconnect.git'

set :deploy_to, '/opt/oneconnect'
set :scm, :git
set :branch, 'master'
set :keep_releases, 5

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

app_name = 'oneconnect'
user = 'deploy'
sudo = '/home/deploy/.rvm/bin/rvmsudo'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [1, 16]
set :puma_workers, 4
set :puma_init_active_record, true
set :puma_preload_app, true

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
     execute "cd #{current_path} && /home/deploy/.rvm/bin/rvm 2.1.2 do bundle exec foreman export upstart /tmp/foreman -a #{app_name} -u #{user} -l /var/#{app_name}/log && sudo cp /tmp/foreman/#{app_name}* /etc/init/"
    end
  end

  desc "Start the application services"
  task :start do

    on roles(:app) do
      execute "#{sudo} service #{app_name} start"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      execute "#{sudo} service #{app_name} stop"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      execute "#{sudo} service #{app_name} start || #{sudo} service #{app_name} restart"
    end
  end
end

namespace :deploy do
  before 'deploy:restart', 'foreman:export'
  task :restart do
    on roles(:app) do

      # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
      execute "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || #{sudo} service #{app_name} restart"

      # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile
    end
  end

  after :publishing, 'deploy:restart'

  after :finishing, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end