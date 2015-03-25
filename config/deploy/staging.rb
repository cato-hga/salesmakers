set :stage, :staging
set :rails_env, 'staging'
set :puma_env, 'staging'
set :puma_init_active_record, true
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :branch, fetch(:branch)

role :app, %w{deploy@staging.salesmakersinc.com}
role :web, %w{deploy@staging.salesmakersinc.com}
role :db, %w{deploy@staging.salesmakersinc.com}

server 'staging.salesmakersinc.com', user: 'deploy', roles: %w{web app}