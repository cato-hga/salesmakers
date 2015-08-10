#!/bin/sh
pg_dump -Fc -h 104.239.197.28 -U oneconnect -f /tmp/dbdump.dump -T comcast_* -T day_sales_counts -T *log_entries -T group_me_* -T candidate_contacts -T *sms_messages -T shifts -T comcast_sales -T sprint_sales -T tmp_* -T workmarket_* oneconnect_production
pg_restore -j 4 -v -d reconnect_development -U reconnect /tmp/dbdump.dump
