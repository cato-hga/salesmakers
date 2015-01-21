# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'oneconnect'
set :repo_url, 'git@bitbucket.org:salesmakers/salesmakers.git'

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

set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :staging do
  desc 'Sync staging and production database'
  task :sync do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:halt'
      execute 'pg_dump -Fc -h 10.209.169.144 -U oneconnect -f /tmp/dbdump.dump oneconnect_production'
      execute 'dropdb -U oneconnect oneconnect_production'
      execute 'createdb -U oneconnect -O oneconnect oneconnect_production'
      execute 'pg_restore -j 4 -v -d oneconnect_production -U oneconnect /tmp/dbdump.dump'
      invoke 'puma:start'
    end
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting, :check_revision
  after :finishing, :compile_assets
  after :finishing, :cleanup
  after :finishing, :restart
end