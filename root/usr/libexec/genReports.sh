#!/bin/sh
export OUTPUT_FILE=/usr/share/nginx/index.html
export LOG_FILE=/pgdata/data/pg_log/postgresql.log

# remove old index.html
[[ -f "$OUTPUT_FILE" ]] || rm -vrf "$OUTPUT_FILE"

cd /opt/pgtools
java LogAnalyzer $LOG_FILE

exit 0
