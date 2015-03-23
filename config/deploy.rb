# config valid only for Capistrano 3.3.5
lock '3.3.5'

set :application, 'oneconnect'
set :repo_url, 'git@bitbucket.org:salesmakers/salesmakers.git'

set :deploy_to, '/opt/oneconnect'
set :scm, :git
set :keep_releases, 5

set :format, :pretty
set :log_level, :debug
set :pty, false

set :linked_files, %w{config/database.yml config/nginx.conf config/staging_nginx.conf}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/sales_charts}

app_name = 'oneconnect'
user = 'deploy'
sudo = '/home/deploy/.rvm/bin/rvmsudo'

set :puma_init_active_record, true
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"

#set :sidekiq_processes, 3
#set :sidekiq_config, 'config/sidekiq.yaml'

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
      invoke 'puma:stop'
    end
    on roles(:app), in: :sequence do
      execute 'sudo service postgresql restart'
      execute 'pg_dump -Fc -h 10.209.169.144 -U oneconnect -f /tmp/dbdump.dump oneconnect_production'
      execute 'dropdb -U oneconnect oneconnect_production'
      execute 'createdb -U oneconnect -O oneconnect oneconnect_production'
      execute 'pg_restore -j 4 -v -d oneconnect_production -U oneconnect /tmp/dbdump.dump'
      invoke 'puma:start'
    end
  end
end

namespace :sidekiq do
  task :restart do
    on roles(:app) do
      execute :sudo, :initctl, :restart, :sidekiq
    end
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    branch = fetch(:branch)
    on roles(:app) do
      unless `git rev-parse HEAD` == "git rev-parse origin/#{branch}"
        puts "WARNING: HEAD is not the same as origin/#{branch}"
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

  desc 'Silence Inspeqtor'
  task :silence_inspeqtor do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo inspeqtorctl start deploy'
    end
  end

  desc 'Start Inspeqtor'
  task :start_inspeqtor do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo inspeqtorctl finish deploy'
    end
  end

  before :starting, :check_revision
  before :starting, :silence_inspeqtor
  after :finishing, :compile_assets
  after :finishing, :cleanup
  after :finishing, :restart
  after :finishing, :start_inspeqtor
end

after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'