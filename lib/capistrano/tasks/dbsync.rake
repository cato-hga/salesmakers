namespace :stagingdata do
  desc 'Sync staging and production database' do
    task :sync do
      on roles(:app), in: :sequence, wait: 1 do
        execute 'pg_dump -Fc -h 10.209.169.144 -U oneconnect -f /tmp/dbdump.dump oneconnect_production'
        execute 'dropdb -U oneconnect oneconnect_production'
        execute 'createdb -U oneconnect -O oneconnect oneconnect_production'
        execute 'pg_restore -j 4 -v -d oneconnect_production -U oneconnect /tmp/dbdump.dump'
      end
    end
  end
end

