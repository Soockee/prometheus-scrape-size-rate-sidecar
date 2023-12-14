FROM ubuntu:20.04

ARG TARGET_DATA_DIR=/var/lib/prometheus
ENV TARGET_DATA_DIR=${TARGET_DATA_DIR}

# Update & upgrade
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y wget cron

# Prepare directories for Node Exporter
RUN mkdir -p /tmp/node_exporter

# Install Node Exporter
RUN wget -O /tmp/node_exporter/node_exporter-1.7.0.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xvf /tmp/node_exporter/node_exporter-1.7.0.linux-amd64.tar.gz -C /tmp/node_exporter/
RUN mv /tmp/node_exporter/node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/

# Copy get_prom_data_size.sh script into the image
COPY --chmod=777 get_prom_data_size.sh get_prom_data_size.sh

# Prepare directories for Node Exporter
# Set up group & user
RUN groupadd -f nobody

COPY --chmod=777 cronjob /etc/cron.d/cronjob

RUN crontab -u nobody /etc/cron.d/cronjob \
    && chmod u+s /usr/sbin/cron

RUN chown -R nobody:nobody /

# Create a startup script
COPY --chmod=777 start.sh start.sh

USER nobody

# Run the startup script when the container starts
ENTRYPOINT ["./start.sh"]
