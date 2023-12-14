#!/bin/bash
echo "Checking ${TARGET_DATA_DIR}"
service cron start

exec node_exporter --web.listen-address=:9200 --collector.disable-defaults --collector.textfile.directory=/var/lib/node_exporter --collector.textfile
