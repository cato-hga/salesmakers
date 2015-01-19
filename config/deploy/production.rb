set :stage, :production

role :app, %w{deploy@new.rbdconnect.com}
role :web, %w{deploy@new.rbdconnect.com}
role :db, %w{deploy@new.rbdconnect.com}

server 'new.rbdconnect.com', user: 'deploy', roles: %w{web app}