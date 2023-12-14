#!/bin/bash
echo "Checking ${TARGET_DATA_DIR}"
echo "Crontabs"
echo "$(crontab -l)"
service cron start

exec node_exporter --web.listen-address=:9200 --collector.disable-defaults --collector.textfile.directory=/tmp/node_exporter/custom_metrics.prom --collector.textfile
