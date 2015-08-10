set :stage, :production

role :app, %w{deploy@newcenter.salesmakersinc.com}
role :web, %w{deploy@newcenter.salesmakersinc.com}
role :db, %w{deploy@newcenter.salesmakersinc.com}
set :branch, 'master'
set :announce_on_slack, true

server 'newcenter.salesmakersinc.com', user: 'deploy', roles: %w{web app}