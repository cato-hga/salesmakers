#!/bin/sh
pg_dump -Fc -h 104.239.197.28 -U oneconnect -f /tmp/dbdump.dump -T comcast_* -T day_sales_counts -T *log_entries -T candidate_contacts -T *sms_messages -T shifts -T *_sales -T *_refunds -T tmp_* -T vonage_* -T workmarket_* oneconnect_production
pg_restore -j 4 -v -d reconnect_development -U reconnect /tmp/dbdump.dump
