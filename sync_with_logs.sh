#!/bin/sh
pg_dump -Fc -h 104.239.197.28 -U oneconnect -f /tmp/dbdump.dump -T comcast_* -T day_sales_counts -T group_me_* -T shifts -T *_sales -T *_refunds -T tmp_* -T vonage_* -T workmarket_* oneconnect_production
#dropdb -U reconnect reconnect_development
#createdb -U reconnect -O reconnect reconnect_development
pg_restore -j 4 -v -d reconnect_development -U reconnect /tmp/dbdump.dump
