FROM ubuntu:20.04

ARG TARGET_DATA_DIR=/var/lib/prometheus
ENV TARGET_DATA_DIR=${TARGET_DATA_DIR}

# Update & upgrade
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y wget cron

# Prepare directories for Node Exporter
RUN mkdir -p /tmp/node_exporter /var/lib/node_exporter

# Install Node Exporter
RUN wget -O /tmp/node_exporter/node_exporter-1.7.0.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xvf /tmp/node_exporter/node_exporter-1.7.0.linux-amd64.tar.gz -C /tmp/node_exporter/
RUN mv /tmp/node_exporter/node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/

# Set up Node Exporter group & user
RUN groupadd -f node_exporter
RUN useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
RUN mkdir /etc/node_exporter
RUN chown node_exporter:node_exporter /etc/node_exporter /usr/local/bin/node_exporter /var/lib/node_exporter

# Copy get_prom_data_size.sh script into the image
COPY get_prom_data_size.sh /tmp/node_exporter/get_prom_data_size.sh
# Set execute permissions for the script
RUN chmod +x /tmp/node_exporter/get_prom_data_size.sh

# Copy cronjob file into the image
COPY cronjob /etc/cron.d/cronjob
RUN crontab /etc/cron.d/cronjob

# Create a startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run the startup script when the container starts
ENTRYPOINT ["/start.sh"]
