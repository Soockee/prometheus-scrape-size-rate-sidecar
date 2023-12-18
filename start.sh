#!/bin/bash
echo "Checking ${TARGET_DATA_DIR}"
echo "Metricfile ${METRICSFILE}"

# Function to handle SIGINT
handle_sigint() {
    echo "Received SIGINT, stopping..."
    kill $! # Kill the last background process
    exit 1
}

# Function to get Prometheus data size
get_prom_data_size() {
    size=$(du -s --block-size=1K "${TARGET_DATA_DIR}" | cut -f1)
    echo "# HELP node_prometheus_data_size_kilobytes Size of specified folder in kilobytes" > "${METRICSFILE}"
    echo "# TYPE node_prometheus_data_size_kilobytes gauge" >> "${METRICSFILE}"
    echo "node_prometheus_data_size_kilobytes ${size}" >> "${METRICSFILE}"
    echo "${TARGET_DATA_DIR} size: ${size}"

    find . -maxdepth 1 -mindepth 1 -type d -exec du -s {} + | awk -v METRICSFILE="${METRICSFILE}" '
        BEGIN {
            printf("# HELP node_prometheus_folder_size_kilobytes Size of block inside specified folder in kilobytes\n");
            printf("# TYPE node_prometheus_folder_size_kilobytes gauge\n");
        }
        {
            sub(/^\.\//, "", $2);
            folder = $2;
            block = (match($2, /[A-Z]/) ? "true" : "false");
            printf("node_prometheus_folder_size_kilobytes{folder=\"%s\", block=\"%s\"} %s\n", folder, block, $1);
        }
    ' >>"${METRICSFILE}"
}

# Trap SIGINT
trap handle_sigint SIGINT

./tmp/node_exporter/node_exporter --web.listen-address=:9200 --collector.disable-defaults --collector.textfile.directory=/tmp/node_exporter/metrics --collector.textfile &

# Loop to continuously update the metrics
while true; do
    echo "Running get_prom_data_size.sh"
    get_prom_data_size
    sleep 20
done

# Bring the background process to the foreground
wait $!