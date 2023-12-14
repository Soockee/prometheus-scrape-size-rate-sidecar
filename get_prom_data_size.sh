#!/bin/bash
echo "# HELP node_prometheus_data_size_kilobytes Size of specified folder in kilobytes
# TYPE node_prometheus_data_size_kilobytes gauge
node_prometheus_data_size_kilobytes $(du -s /var/lib/prometheus 2>/dev/null | cut -f1)" >/var/lib/node_exporter/custom_metrics.prom
