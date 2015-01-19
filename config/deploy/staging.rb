set :stage, :staging
set :rails_env, 'staging'
set :puma_env, 'staging'

role :app, %w{deploy@staging.rbdconnect.com}
role :web, %w{deploy@staging.rbdconnect.com}
role :db, %w{deploy@staging.rbdconnect.com}

server 'staging.rbdconnect.com', user: 'deploy', roles: %w{web app}