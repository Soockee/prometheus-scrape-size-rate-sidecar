FROM ubuntu:20.04

ARG TARGET_DATA_DIR=/var/lib/prometheus
ENV TARGET_DATA_DIR=${TARGET_DATA_DIR}

# Update & upgrade
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y wget curl vim

# Prepare directories for Node Exporter
RUN mkdir -p /tmp/node_exporter
# Prepare directories for Node Exporter
# Set up group & user
RUN groupadd -f nobody

# Install Node Exporter
RUN wget -O /tmp/node_exporter/node_exporter-1.7.0.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xvf /tmp/node_exporter/node_exporter-1.7.0.linux-amd64.tar.gz -C /tmp/node_exporter/
RUN mv /tmp/node_exporter/node_exporter-1.7.0.linux-amd64/node_exporter /tmp/node_exporter/node_exporter

COPY --chmod=777 custom_metrics.prom /tmp/node_exporter/metrics/custom_metrics.prom
RUN chown -R nobody:nobody /tmp/node_exporter

# Create a startup script
COPY --chmod=777 start.sh start.sh

USER nobody

# Run the startup script when the container starts
ENTRYPOINT ["./start.sh"]
