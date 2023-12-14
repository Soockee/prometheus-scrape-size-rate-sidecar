#!/bin/bash
echo "# HELP node_prometheus_data_size_kilobytes Size of specified folder in kilobytes
# TYPE node_prometheus_data_size_kilobytes gauge
node_prometheus_data_size_kilobytes $(du -s ${TARGET_DATA_DIR} 2>/dev/null | cut -f1)" >/custom_metrics.prom
