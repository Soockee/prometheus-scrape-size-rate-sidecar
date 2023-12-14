#!/bin/bash
echo "Checking ${TARGET_DATA_DIR}"

# Function to get Prometheus data size
get_prom_data_size() {
    size=$(du -s "${TARGET_DATA_DIR}" | cut -f1)
    echo "# HELP node_prometheus_data_size_kilobytes Size of specified folder in kilobytes
    # TYPE node_prometheus_data_size_kilobytes gauge
    node_prometheus_data_size_kilobytes ${size}" >/tmp/node_exporter/metrics/custom_metrics.prom
    echo "${TARGET_DATA_DIR} size:${size}" 
}

get_prom_data_size

# Loop to continuously update the metrics
while true; do
    echo "Running get_prom_data_size.sh"
    get_prom_data_size
    sleep 20
done &


./tmp/node_exporter/node_exporter --web.listen-address=:9200 --collector.disable-defaults --collector.textfile.directory=/tmp/node_exporter/metrics --collector.textfile
