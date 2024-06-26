#!/bin/bash

# Create Prometheus system user
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Create necessary directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Set ownership of the directories to the Prometheus user
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz

# Extract Prometheus tarball
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz

# Move Prometheus binaries to /usr/local/bin
sudo mv prometheus-2.47.1.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.47.1.linux-amd64/promtool /usr/local/bin/

# Set ownership of the binaries to the Prometheus user
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Move Prometheus configuration files to /etc/prometheus
sudo mv prometheus-2.47.1.linux-amd64/consoles /etc/prometheus
sudo mv prometheus-2.47.1.linux-amd64/console_libraries /etc/prometheus
sudo mv prometheus-2.47.1.linux-amd64/prometheus.yml /etc/prometheus

# Set ownership of the configuration files to the Prometheus user
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Clean up
rm -rf prometheus-2.47.1.linux-amd64.tar.gz prometheus-2.47.1.linux-amd64

# Create systemd service file for Prometheus
sudo bash -c 'cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd to apply the new service
sudo systemctl daemon-reload

# Start Prometheus service
sudo systemctl start prometheus

# Enable Prometheus service to start on boot
sudo systemctl enable prometheus

# Inform that Prometheus installation and configuration is completed
echo "Prometheus installation and configuration completed successfully." > /var/log/user-data.log

# Check Prometheus status and add output to log
systemctl status prometheus >> /var/log/user-data.log

#################################### NODE EXPORTER ####################################
# Install Node Exporter
# Create Node Exporter system user
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# Download Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

# Extract Node Exporter files
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

# Move Node Exporter binary to /usr/local/bin
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/

# Set ownership of the binary to the Node Exporter user
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Clean up
rm -rf node_exporter-1.6.1.linux-amd64.tar.gz node_exporter-1.6.1.linux-amd64

# Create systemd service file for Node Exporter
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter --collector.logind

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd to apply the new service
sudo systemctl daemon-reload

# Start Node Exporter service
sudo systemctl start node_exporter

# Enable Node Exporter service to start on boot
sudo systemctl enable node_exporter

# Inform that Node Exporter installation and configuration is completed
echo "Node Exporter installation and configuration completed successfully." >> /var/log/user-data.log

# Check Node Exporter status and add output to log
systemctl status node_exporter >> /var/log/user-data.log

#################################### GRAFANA ####################################

# Install Grafana
# Install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common

# Add GPG key for Grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Add Grafana repository
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update package list and install Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Inform that Grafana installation and configuration is completed
echo "Grafana installation and configuration completed successfully." >> /var/log/user-data.log

# Check Grafana status and add output to log
systemctl status grafana-server >> /var/log/user-data.log