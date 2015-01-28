#!/bin/sh
pg_dump -Fc -h 23.253.161.5 -U oneconnect -f /tmp/dbdump.dump oneconnect_production
dropdb -U reconnect reconnect_development
createdb -U reconnect -O reconnect reconnect_development
pg_restore -j 4 -v -d reconnect_development -U reconnect /tmp/dbdump.dump