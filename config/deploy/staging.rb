set :stage, :staging

role :app, %w{deploy@staging.rbdconnect.com}
role :web, %w{deploy@staging.rbdconnect.com}
role :db, %w{deploy@staging.rbdconnect.com}
role :staging, %w{deploy@staging.rbdconnect.com}

server 'staging.rbdconnect.com', user: 'deploy', roles: %w{web app}